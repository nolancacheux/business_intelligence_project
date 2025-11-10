"""
Script simple pour charger les données CSV directement dans PostgreSQL
Alternative au pipeline Airflow pour tests rapides
"""

import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
import os
from pathlib import Path
import re

# Configuration
DATA_DIR = Path("data/sources")
DB_CONFIG = {
    "host": os.getenv("POSTGRES_HOST", "localhost"),
    "port": os.getenv("POSTGRES_PORT", "5432"),
    "database": os.getenv("POSTGRES_DB", "cresus_db"),
    "user": os.getenv("POSTGRES_USER", "postgres"),
    "password": os.getenv("POSTGRES_PASSWORD", "postgres")
}

# Dictionnaire de mapping pays -> région
PAYS_REGION_MAPPING = {
    "France": "Europe",
    "Allemagne": "Europe",
    "Royaume-Uni": "Europe",
    "Suisse": "Europe",
    "Espagne": "Europe",
    "Italie": "Europe",
}

# Dictionnaire de normalisation type_contrepartie
TYPE_CONTREPARTIE_MAPPING = {
    "client": "Client",
    "fournisseur": "Fournisseur",
    "banque": "Banque partenaire",
    "institution": "Institution financière",
}


def clean_amount(amount):
    """Nettoie le montant en supprimant les caractères non numériques"""
    if pd.isna(amount):
        return None
    amount_str = str(amount)
    cleaned = re.sub(r'[^\d\.\-]', '', amount_str)
    try:
        return float(cleaned) if cleaned else None
    except:
        return None


def mask_account_number(numero):
    """Masque partiellement un numéro de compte"""
    if pd.isna(numero):
        return numero
    numero_str = str(numero).strip()
    if len(numero_str) > 8:
        masked = numero_str[:4] + " **** **** **** " + numero_str[-4:]
    else:
        masked = numero_str
    return masked


def normalize_type_contrepartie(type_str):
    """Normalise le type de contrepartie"""
    if pd.isna(type_str):
        return type_str
    type_lower = str(type_str).lower().strip()
    for key, value in TYPE_CONTREPARTIE_MAPPING.items():
        if key in type_lower:
            return value
    return type_str


def main():
    print("=" * 60)
    print("Chargement des donnees CSV dans PostgreSQL")
    print("=" * 60)
    
    # Connexion à PostgreSQL
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print("Connexion a PostgreSQL etablie")
    except Exception as e:
        print(f"Erreur de connexion: {e}")
        return
    
    # Vider les tables existantes (pour rechargement propre)
    print("\nNettoyage des tables existantes...")
    cursor.execute("TRUNCATE TABLE FACT_FLUX_TRESORERIE CASCADE;")
    cursor.execute("TRUNCATE TABLE DIM_COMPTE CASCADE;")
    cursor.execute("TRUNCATE TABLE DIM_TEMPS CASCADE;")
    cursor.execute("TRUNCATE TABLE DIM_SCENARIO CASCADE;")
    cursor.execute("TRUNCATE TABLE DIM_DEVISE CASCADE;")
    cursor.execute("TRUNCATE TABLE DIM_FILIALE CASCADE;")
    cursor.execute("TRUNCATE TABLE DIM_CONTREPARTIE CASCADE;")
    print("Tables nettoyees")
    
    # Charger les dimensions dans l'ordre des dépendances
    
    # 1. DIM_DEVISE
    print("\nChargement DIM_DEVISE...")
    df_devise = pd.read_csv(DATA_DIR / "dim_devise.csv")
    execute_values(
        cursor,
        "INSERT INTO DIM_DEVISE (id_devise, code_iso, libelle_devise) VALUES %s",
        [tuple(int(x) if isinstance(x, (int, float)) and not pd.isna(x) else x for x in row) for row in df_devise[['id_devise', 'code_iso', 'libelle_devise']].values]
    )
    print(f"  {len(df_devise)} lignes inserees")
    
    # 2. DIM_FILIALE (avec ajout automatique de région)
    print("\nChargement DIM_FILIALE...")
    df_filiale = pd.read_csv(DATA_DIR / "dim_filiale.csv")
    df_filiale['region'] = df_filiale['pays'].map(PAYS_REGION_MAPPING).fillna(df_filiale['region'])
    execute_values(
        cursor,
        "INSERT INTO DIM_FILIALE (id_filiale, nom_filiale, pays, region) VALUES %s",
        [tuple(int(x) if isinstance(x, (int, float)) and not pd.isna(x) else x for x in row) for row in df_filiale[['id_filiale', 'nom_filiale', 'pays', 'region']].values]
    )
    print(f"  {len(df_filiale)} lignes inserees")
    
    # 3. DIM_SCENARIO
    print("\nChargement DIM_SCENARIO...")
    df_scenario = pd.read_csv(DATA_DIR / "dim_scenario.csv")
    execute_values(
        cursor,
        "INSERT INTO DIM_SCENARIO (id_scenario, nom_scenario, description) VALUES %s",
        [tuple(int(x) if isinstance(x, (int, float)) and not pd.isna(x) else x for x in row) for row in df_scenario[['id_scenario', 'nom_scenario', 'description']].values]
    )
    print(f"  {len(df_scenario)} lignes inserees")
    
    # 4. DIM_CONTREPARTIE (avec normalisation)
    print("\nChargement DIM_CONTREPARTIE...")
    df_contrepartie = pd.read_csv(DATA_DIR / "dim_contrepartie.csv")
    df_contrepartie['type_contrepartie'] = df_contrepartie['type_contrepartie'].apply(normalize_type_contrepartie)
    execute_values(
        cursor,
        "INSERT INTO DIM_CONTREPARTIE (id_contrepartie, nom_contrepartie, type_contrepartie) VALUES %s",
        [tuple(int(x) if isinstance(x, (int, float)) and not pd.isna(x) else x for x in row) for row in df_contrepartie[['id_contrepartie', 'nom_contrepartie', 'type_contrepartie']].values]
    )
    print(f"  {len(df_contrepartie)} lignes inserees")
    
    # 5. DIM_TEMPS
    print("\nChargement DIM_TEMPS...")
    df_temps = pd.read_csv(DATA_DIR / "dim_temps.csv")
    # Convertir explicitement en types Python natifs
    df_temps = df_temps.astype({'id_temps': 'int64', 'jour': 'int64', 'mois': 'int64', 'annee': 'int64'})
    rows = []
    for _, row in df_temps.iterrows():
        rows.append((int(row['id_temps']), int(row['jour']), int(row['mois']), int(row['annee'])))
    execute_values(
        cursor,
        "INSERT INTO DIM_TEMPS (id_temps, jour, mois, annee) VALUES %s",
        rows
    )
    print(f"  {len(df_temps)} lignes inserees")
    
    # 6. DIM_COMPTE (avec masquage des numéros)
    print("\nChargement DIM_COMPTE...")
    df_compte = pd.read_csv(DATA_DIR / "dim_compte.csv")
    df_compte['numero_compte'] = df_compte['numero_compte'].apply(mask_account_number)
    execute_values(
        cursor,
        "INSERT INTO DIM_COMPTE (id_compte, numero_compte, type_compte, id_devise, id_filiale) VALUES %s",
        [tuple(int(x) if isinstance(x, (int, float)) and not pd.isna(x) else x for x in row) for row in df_compte[['id_compte', 'numero_compte', 'type_compte', 'id_devise', 'id_filiale']].values]
    )
    print(f"  {len(df_compte)} lignes inserees")
    
    # 7. FACT_FLUX_TRESORERIE (avec transformations)
    print("\nChargement FACT_FLUX_TRESORERIE...")
    df_fact = pd.read_csv(DATA_DIR / "fact_flux_tresorerie.csv")
    
    # Transformations
    df_fact['date_operation'] = pd.to_datetime(df_fact['date_operation'], errors='coerce').dt.date
    df_fact['montant_transaction'] = df_fact['montant_transaction'].apply(clean_amount)
    df_fact['type_operation'] = df_fact['type_operation'].str.lower().str.strip()
    df_fact['montant_consolide_eur'] = df_fact['montant_consolide_eur'].fillna(df_fact['montant_transaction'])
    
    # Nettoyer les valeurs NaN
    df_fact_clean = df_fact.dropna(subset=['date_operation', 'montant_transaction', 'id_compte', 'id_devise', 'id_scenario', 'id_temps', 'id_contrepartie'])
    
    # Convertir les valeurs numpy en types Python natifs
    def convert_row(row):
        result = []
        for val in row:
            if pd.isna(val):
                result.append(None)
            elif isinstance(val, (int, float)) and not isinstance(val, bool):
                if isinstance(val, float):
                    result.append(float(val))
                else:
                    result.append(int(val))
            else:
                result.append(val)
        return tuple(result)
    
    execute_values(
        cursor,
        """INSERT INTO FACT_FLUX_TRESORERIE 
        (date_operation, montant_transaction, montant_consolide_eur, type_operation, statut,
         id_compte, id_devise, id_scenario, id_temps, id_contrepartie)
        VALUES %s""",
        [convert_row(row) for row in df_fact_clean[[
            'date_operation', 'montant_transaction', 'montant_consolide_eur',
            'type_operation', 'statut', 'id_compte', 'id_devise',
            'id_scenario', 'id_temps', 'id_contrepartie'
        ]].values]
    )
    print(f"  {len(df_fact_clean)} lignes inserees")
    
    # Commit
    conn.commit()
    cursor.close()
    conn.close()
    
    print("\n" + "=" * 60)
    print("Chargement termine avec succes!")
    print("=" * 60)
    
    # Vérification
    conn = psycopg2.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(*) FROM FACT_FLUX_TRESORERIE;")
    count = cursor.fetchone()[0]
    print(f"\nNombre total de transactions dans FACT_FLUX_TRESORERIE: {count}")
    cursor.close()
    conn.close()


if __name__ == "__main__":
    main()

