"""
Modèle prédictif de régression linéaire pour les prévisions de trésorerie
Génère des prévisions à 30 jours pour chaque filiale/compte
"""

import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from datetime import datetime, timedelta
import psycopg2
from psycopg2.extras import execute_values
import os
from pathlib import Path

# Configuration de la base de données (peut être surchargée par variables d'environnement)
DB_CONFIG = {
    "host": os.getenv("POSTGRES_HOST", "localhost"),
    "port": os.getenv("POSTGRES_PORT", "5432"),
    "database": os.getenv("POSTGRES_DB", "cresus_db"),
    "user": os.getenv("POSTGRES_USER", "postgres"),
    "password": os.getenv("POSTGRES_PASSWORD", "postgres")
}


def get_historical_data(conn):
    """
    Récupère les données historiques de trésorerie depuis PostgreSQL
    """
    query = """
    SELECT 
        f.date_operation,
        f.montant_consolide_eur,
        f.id_compte,
        c.id_filiale,
        t.annee,
        t.mois,
        t.jour
    FROM FACT_FLUX_TRESORERIE f
    JOIN DIM_COMPTE c ON f.id_compte = c.id_compte
    JOIN DIM_TEMPS t ON f.id_temps = t.id_temps
    WHERE f.statut = 'Réalisé'
      AND f.montant_consolide_eur IS NOT NULL
    ORDER BY f.date_operation, f.id_compte
    """
    
    df = pd.read_sql_query(query, conn, parse_dates=['date_operation'])
    return df


def prepare_features(df):
    """
    Prépare les features pour le modèle de régression linéaire
    """
    df = df.copy()
    
    # Créer des features temporelles
    df['jour_semaine'] = df['date_operation'].dt.dayofweek
    df['jour_mois'] = df['date_operation'].dt.day
    df['mois'] = df['date_operation'].dt.month
    df['annee'] = df['date_operation'].dt.year
    
    # Feature de tendance (nombre de jours depuis le début)
    df['jours_depuis_debut'] = (df['date_operation'] - df['date_operation'].min()).dt.days
    
    # Moyenne mobile sur 7 jours (pour capturer les tendances)
    df = df.sort_values(['id_compte', 'date_operation'])
    df['moyenne_mobile_7j'] = df.groupby('id_compte')['montant_consolide_eur'].transform(
        lambda x: x.rolling(window=7, min_periods=1).mean()
    )
    
    return df


def train_and_predict(df, id_compte, forecast_days=30):
    """
    Entraîne un modèle de régression linéaire pour un compte donné
    et génère des prévisions
    """
    # Filtrer les données pour ce compte
    compte_data = df[df['id_compte'] == id_compte].copy()
    
    if len(compte_data) < 30:  # Pas assez de données historiques
        return None
    
    # Préparer les features
    compte_data = prepare_features(compte_data)
    
    # Features pour l'entraînement
    feature_cols = ['jour_semaine', 'jour_mois', 'mois', 'jours_depuis_debut', 'moyenne_mobile_7j']
    X_train = compte_data[feature_cols].values
    y_train = compte_data['montant_consolide_eur'].values
    
    # Entraîner le modèle
    model = LinearRegression()
    model.fit(X_train, y_train)
    
    # Générer les dates de prévision
    last_date = compte_data['date_operation'].max()
    forecast_dates = [last_date + timedelta(days=i+1) for i in range(forecast_days)]
    
    # Préparer les features pour les prévisions
    forecasts = []
    for i, forecast_date in enumerate(forecast_dates):
        jours_depuis_debut = (forecast_date - compte_data['date_operation'].min()).days
        
        # Calculer la moyenne mobile pour la prévision (utiliser la dernière valeur connue)
        derniere_moyenne_mobile = compte_data['moyenne_mobile_7j'].iloc[-1]
        
        features = np.array([[
            forecast_date.weekday(),  # jour_semaine
            forecast_date.day,       # jour_mois
            forecast_date.month,     # mois
            jours_depuis_debut,      # jours_depuis_debut
            derniere_moyenne_mobile  # moyenne_mobile_7j
        ]])
        
        # Prédire
        prediction = model.predict(features)[0]
        
        forecasts.append({
            'date_operation': forecast_date,
            'montant_consolide_eur': prediction,
            'id_compte': id_compte
        })
    
    return forecasts


def insert_forecasts(conn, forecasts, id_scenario_previsionnel=2):
    """
    Insère les prévisions dans la base de données
    """
    if not forecasts:
        return
    
    # Fonction helper pour convertir les valeurs numpy en types Python natifs
    def convert_value(val):
        """Convertit une valeur numpy en type Python natif"""
        if pd.isna(val):
            return None
        elif isinstance(val, (np.integer, np.int64, np.int32)):
            return int(val)
        elif isinstance(val, (np.floating, np.float64, np.float32)):
            return float(val)
        elif isinstance(val, (int, float)) and not isinstance(val, bool):
            return val
        else:
            return val
    
    # Récupérer les IDs de temps pour les dates de prévision
    cursor = conn.cursor()
    
    # Créer un DataFrame pour faciliter les jointures
    forecasts_df = pd.DataFrame(forecasts)
    
    # Récupérer les informations nécessaires pour chaque compte
    for forecast in forecasts:
        date_op = forecast['date_operation']
        id_compte = convert_value(forecast['id_compte'])
        
        # Récupérer id_temps
        cursor.execute("""
            SELECT id_temps FROM DIM_TEMPS
            WHERE jour = %s AND mois = %s AND annee = %s
        """, (date_op.day, date_op.month, date_op.year))
        
        result = cursor.fetchone()
        if not result:
            continue
        
        id_temps = convert_value(result[0])
        
        # Récupérer les informations du compte
        cursor.execute("""
            SELECT id_devise, id_filiale FROM DIM_COMPTE WHERE id_compte = %s
        """, (id_compte,))
        
        compte_info = cursor.fetchone()
        if not compte_info:
            continue
        
        id_devise = convert_value(compte_info[0])
        id_filiale = convert_value(compte_info[1])
        
        # Générer un montant transaction basé sur la prévision
        # (le montant_consolide_eur est déjà en EUR, donc on peut l'utiliser directement)
        montant_transaction = convert_value(forecast['montant_consolide_eur'])
        montant_consolide_eur = convert_value(forecast['montant_consolide_eur'])
        
        # Insérer la prévision
        cursor.execute("""
            INSERT INTO FACT_FLUX_TRESORERIE 
            (date_operation, montant_transaction, montant_consolide_eur, 
             type_operation, statut, id_compte, id_devise, id_scenario, id_temps, id_contrepartie)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            date_op,
            montant_transaction,
            montant_consolide_eur,
            'Prévision modèle',
            'Prévisionnel',
            id_compte,
            id_devise,
            convert_value(id_scenario_previsionnel),
            id_temps,
            convert_value(1)  # Contrepartie par défaut
        ))
    
    conn.commit()
    cursor.close()


def main():
    """
    Fonction principale : génère les prévisions pour tous les comptes
    """
    print("=" * 60)
    print("Modèle prédictif - Génération des prévisions à 30 jours")
    print("=" * 60)
    
    # Connexion à la base de données
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("✓ Connexion à PostgreSQL établie")
    except Exception as e:
        print(f"✗ Erreur de connexion à PostgreSQL : {e}")
        return
    
    # Récupérer les données historiques
    print("Récupération des données historiques...")
    df = get_historical_data(conn)
    print(f"✓ {len(df)} enregistrements historiques récupérés")
    
    if len(df) == 0:
        print("✗ Aucune donnée historique trouvée")
        conn.close()
        return
    
    # Obtenir la liste des comptes uniques
    comptes_uniques = df['id_compte'].unique()
    print(f"✓ {len(comptes_uniques)} comptes à traiter")
    
    # Générer les prévisions pour chaque compte
    all_forecasts = []
    comptes_traites = 0
    
    for id_compte in comptes_uniques:
        forecasts = train_and_predict(df, id_compte, forecast_days=30)
        if forecasts:
            all_forecasts.extend(forecasts)
            comptes_traites += 1
    
    print(f"✓ Prévisions générées pour {comptes_traites} comptes")
    print(f"✓ {len(all_forecasts)} prévisions au total")
    
    # Insérer les prévisions dans la base de données
    if all_forecasts:
        print("Insertion des prévisions dans la base de données...")
        insert_forecasts(conn, all_forecasts)
        print("✓ Prévisions insérées avec succès")
    
    conn.close()
    print("=" * 60)
    print("✓ Modélisation terminée avec succès!")
    print("=" * 60)


if __name__ == "__main__":
    main()

