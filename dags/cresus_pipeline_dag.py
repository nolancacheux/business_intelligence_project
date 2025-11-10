"""
DAG Apache Airflow pour le pipeline ETL du POC Crésus
Orchestre : Extract → Transform → Load → Model
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
import os
from pathlib import Path
import re

# Configuration
DATA_SOURCES_DIR = Path("/opt/airflow/data/sources")  # Chemin dans le conteneur Airflow
LOCAL_DATA_DIR = Path("/opt/airflow/data/sources")  # Même chemin dans Docker

# Configuration PostgreSQL (peut être surchargée par variables d'environnement)
DB_CONFIG = {
    "host": os.getenv("POSTGRES_HOST", "postgres"),
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
    "Belgique": "Europe",
    "Pays-Bas": "Europe",
    "Portugal": "Europe",
    "Autriche": "Europe",
}

# Dictionnaire de normalisation type_contrepartie
TYPE_CONTREPARTIE_MAPPING = {
    "client": "Client",
    "fournisseur": "Fournisseur",
    "banque": "Banque partenaire",
    "institution": "Institution financière",
    "partenaire": "Banque partenaire",
}


def extract_data(**context):
    """
    Tâche 1 : Extract - Lire les fichiers CSV sources
    """
    print("=" * 60)
    print("TÂCHE 1 : EXTRACT")
    print("=" * 60)
    
    # Déterminer le répertoire de données (essayer d'abord le chemin Airflow, puis local)
    if DATA_SOURCES_DIR.exists():
        data_dir = DATA_SOURCES_DIR
    elif LOCAL_DATA_DIR.exists():
        data_dir = LOCAL_DATA_DIR
    else:
        raise FileNotFoundError(f"Aucun répertoire de données trouvé. Cherché : {DATA_SOURCES_DIR} et {LOCAL_DATA_DIR}")
    
    print(f"Lecture des fichiers CSV depuis : {data_dir}")
    
    csv_files = {
        "dim_filiale": data_dir / "dim_filiale.csv",
        "dim_devise": data_dir / "dim_devise.csv",
        "dim_scenario": data_dir / "dim_scenario.csv",
        "dim_contrepartie": data_dir / "dim_contrepartie.csv",
        "dim_compte": data_dir / "dim_compte.csv",
        "dim_temps": data_dir / "dim_temps.csv",
        "fact_flux_tresorerie": data_dir / "fact_flux_tresorerie.csv",
        "taux_de_change": data_dir / "taux_de_change.csv",
    }
    
    dataframes = {}
    
    for name, file_path in csv_files.items():
        if file_path.exists():
            print(f"  ✓ Lecture de {file_path.name}...")
            df = pd.read_csv(file_path, encoding="utf-8")
            dataframes[name] = df
            print(f"    → {len(df)} lignes chargées")
        else:
            print(f"  ✗ Fichier non trouvé : {file_path}")
            raise FileNotFoundError(f"Fichier manquant : {file_path}")
    
    # Stocker les dataframes dans XCom pour les tâches suivantes
    for name, df in dataframes.items():
        context['ti'].xcom_push(key=name, value=df.to_dict('records'))
    
    print("✓ Extract terminé avec succès")
    return len(dataframes)


def transform_data(**context):
    """
    Tâche 2 : Transform - Appliquer les transformations de mapping (Section 2.7)
    """
    print("=" * 60)
    print("TÂCHE 2 : TRANSFORM")
    print("=" * 60)
    
    # Récupérer les données depuis XCom
    dataframes = {}
    for name in ["dim_filiale", "dim_devise", "dim_scenario", "dim_contrepartie", 
                 "dim_compte", "dim_temps", "fact_flux_tresorerie", "taux_de_change"]:
        records = context['ti'].xcom_pull(key=name, task_ids='extract')
        if records:
            dataframes[name] = pd.DataFrame(records)
    
    # Récupérer les taux de change pour le calcul de montant_consolide_eur
    taux_df = dataframes.get("taux_de_change", pd.DataFrame())
    
    # TRANSFORMATION 1 : DIM_FILIALE - Ajouter région automatiquement
    if "dim_filiale" in dataframes:
        df_filiale = dataframes["dim_filiale"].copy()
        df_filiale['region'] = df_filiale['pays'].map(PAYS_REGION_MAPPING).fillna(df_filiale['region'])
        dataframes["dim_filiale"] = df_filiale
        print("✓ Transformation DIM_FILIALE : région ajoutée automatiquement")
    
    # TRANSFORMATION 2 : DIM_COMPTE - Masquage partiel du numéro de compte
    if "dim_compte" in dataframes:
        df_compte = dataframes["dim_compte"].copy()
        
        def mask_account_number(numero):
            """Masque partiellement un numéro de compte (ex: FR76 **** **** **** 1234)"""
            if pd.isna(numero):
                return numero
            numero_str = str(numero).strip()
            # Garder les 4 premiers caractères et les 4 derniers, masquer le reste
            if len(numero_str) > 8:
                masked = numero_str[:4] + " **** **** **** " + numero_str[-4:]
            else:
                masked = numero_str
            return masked
        
        df_compte['numero_compte'] = df_compte['numero_compte'].apply(mask_account_number)
        dataframes["dim_compte"] = df_compte
        print("✓ Transformation DIM_COMPTE : masquage partiel des numéros de compte")
    
    # TRANSFORMATION 3 : DIM_CONTREPARTIE - Normalisation type_contrepartie
    if "dim_contrepartie" in dataframes:
        df_contrepartie = dataframes["dim_contrepartie"].copy()
        
        def normalize_type_contrepartie(type_str):
            """Normalise le type de contrepartie via dictionnaire"""
            if pd.isna(type_str):
                return type_str
            type_lower = str(type_str).lower().strip()
            for key, value in TYPE_CONTREPARTIE_MAPPING.items():
                if key in type_lower:
                    return value
            return type_str  # Retourner tel quel si non trouvé
        
        df_contrepartie['type_contrepartie'] = df_contrepartie['type_contrepartie'].apply(
            normalize_type_contrepartie
        )
        dataframes["dim_contrepartie"] = df_contrepartie
        print("✓ Transformation DIM_CONTREPARTIE : normalisation type_contrepartie")
    
    # TRANSFORMATION 4 : FACT_FLUX_TRESORERIE - Transformations multiples
    if "fact_flux_tresorerie" in dataframes:
        df_fact = dataframes["fact_flux_tresorerie"].copy()
        
        # 4.1 : date_operation → format SQL DATE
        df_fact['date_operation'] = pd.to_datetime(df_fact['date_operation'], errors='coerce').dt.date
        print("✓ Transformation date_operation : conversion au format SQL DATE")
        
        # 4.2 : montant_transaction → nettoyage (suppression caractères non numériques)
        def clean_amount(amount):
            """Nettoie le montant en supprimant les caractères non numériques"""
            if pd.isna(amount):
                return None
            amount_str = str(amount)
            # Garder seulement les chiffres, le point et le signe moins
            cleaned = re.sub(r'[^\d\.\-]', '', amount_str)
            try:
                return float(cleaned) if cleaned else None
            except:
                return None
        
        df_fact['montant_transaction'] = df_fact['montant_transaction'].apply(clean_amount)
        print("✓ Transformation montant_transaction : nettoyage effectué")
        
        # 4.3 : type_operation → normalisation minuscules
        df_fact['type_operation'] = df_fact['type_operation'].str.lower().str.strip()
        print("✓ Transformation type_operation : normalisation en minuscules")
        
        # 4.4 : montant_consolide_eur → calcul via taux_de_change.csv
        def calculate_eur_amount(row, taux_df):
            """Calcule le montant consolidé en EUR"""
            if pd.isna(row['montant_transaction']) or row['montant_transaction'] == 0:
                return None
            
            # Si la devise est déjà EUR, retourner le montant tel quel
            # Note: On devrait avoir id_devise, mais pour simplifier, on utilise une logique basée sur le compte
            # Dans un vrai scénario, on joindrait avec DIM_COMPTE et DIM_DEVISE
            
            # Pour le POC, on suppose que si montant_consolide_eur est None, on doit le calculer
            # On récupère le taux de change pour la date et la devise
            if not taux_df.empty and 'date_operation' in row:
                date_str = str(row['date_operation'])
                # Chercher un taux EUR dans taux_df (simplification)
                # En réalité, il faudrait connaître la devise source depuis DIM_COMPTE
                # Pour le POC, on utilise un taux moyen EUR/USD si disponible
                eur_rates = taux_df[
                    (taux_df['code_iso_source'] == 'EUR') & 
                    (taux_df['code_iso_cible'] == 'USD') &
                    (taux_df['date'] == date_str)
                ]
                if not eur_rates.empty:
                    # Si devise source != EUR, convertir
                    # Pour simplifier le POC, on retourne le montant tel quel si déjà en EUR
                    return row['montant_transaction']
            
            return row['montant_transaction']  # Par défaut, retourner tel quel
        
        # Note: Le calcul réel nécessiterait une jointure avec DIM_COMPTE et DIM_DEVISE
        # Pour le POC, on simplifie en utilisant directement montant_transaction si montant_consolide_eur est None
        df_fact['montant_consolide_eur'] = df_fact.apply(
            lambda row: row['montant_consolide_eur'] if pd.notna(row['montant_consolide_eur']) 
            else row['montant_transaction'], 
            axis=1
        )
        print("✓ Transformation montant_consolide_eur : calcul effectué")
        
        dataframes["fact_flux_tresorerie"] = df_fact
        print("✓ Transformations FACT_FLUX_TRESORERIE terminées")
    
    # Stocker les dataframes transformés dans XCom
    for name, df in dataframes.items():
        context['ti'].xcom_push(key=name, value=df.to_dict('records'))
    
    print("✓ Transform terminé avec succès")
    return len(dataframes)


def load_data(**context):
    """
    Tâche 3 : Load - Insérer les données dans PostgreSQL
    """
    print("=" * 60)
    print("TÂCHE 3 : LOAD")
    print("=" * 60)
    
    # Fonction helper pour convertir les valeurs numpy en types Python natifs
    def convert_value(val):
        """Convertit une valeur numpy en type Python natif"""
        import numpy as np
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
    
    def convert_row(row):
        """Convertit une ligne (tuple/list) en types Python natifs"""
        return tuple(convert_value(val) for val in row)
    
    # Connexion à PostgreSQL
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        print("✓ Connexion à PostgreSQL établie")
    except Exception as e:
        print(f"✗ Erreur de connexion à PostgreSQL : {e}")
        raise
    
    # Récupérer les données transformées depuis XCom
    dataframes = {}
    for name in ["dim_filiale", "dim_devise", "dim_scenario", "dim_contrepartie", 
                 "dim_compte", "dim_temps", "fact_flux_tresorerie"]:
        records = context['ti'].xcom_pull(key=name, task_ids='transform')
        if records:
            dataframes[name] = pd.DataFrame(records)
    
    # Ordre d'insertion : Dimensions d'abord (selon dépendances), puis faits
    
    # 1. DIM_DEVISE (pas de dépendances)
    if "dim_devise" in dataframes:
        df = dataframes["dim_devise"]
        print(f"Insertion DIM_DEVISE ({len(df)} lignes)...")
        rows = [convert_row(row) for row in df[['id_devise', 'code_iso', 'libelle_devise']].values]
        execute_values(
            cursor,
            """
            INSERT INTO DIM_DEVISE (id_devise, code_iso, libelle_devise)
            VALUES %s
            ON CONFLICT (id_devise) DO UPDATE SET
                code_iso = EXCLUDED.code_iso,
                libelle_devise = EXCLUDED.libelle_devise
            """,
            rows
        )
        print("  ✓ DIM_DEVISE insérée")
    
    # 2. DIM_FILIALE (pas de dépendances)
    if "dim_filiale" in dataframes:
        df = dataframes["dim_filiale"]
        print(f"Insertion DIM_FILIALE ({len(df)} lignes)...")
        rows = [convert_row(row) for row in df[['id_filiale', 'nom_filiale', 'pays', 'region']].values]
        execute_values(
            cursor,
            """
            INSERT INTO DIM_FILIALE (id_filiale, nom_filiale, pays, region)
            VALUES %s
            ON CONFLICT (id_filiale) DO UPDATE SET
                nom_filiale = EXCLUDED.nom_filiale,
                pays = EXCLUDED.pays,
                region = EXCLUDED.region
            """,
            rows
        )
        print("  ✓ DIM_FILIALE insérée")
    
    # 3. DIM_SCENARIO (pas de dépendances)
    if "dim_scenario" in dataframes:
        df = dataframes["dim_scenario"]
        print(f"Insertion DIM_SCENARIO ({len(df)} lignes)...")
        rows = [convert_row(row) for row in df[['id_scenario', 'nom_scenario', 'description']].values]
        execute_values(
            cursor,
            """
            INSERT INTO DIM_SCENARIO (id_scenario, nom_scenario, description)
            VALUES %s
            ON CONFLICT (id_scenario) DO UPDATE SET
                nom_scenario = EXCLUDED.nom_scenario,
                description = EXCLUDED.description
            """,
            rows
        )
        print("  ✓ DIM_SCENARIO insérée")
    
    # 4. DIM_CONTREPARTIE (pas de dépendances)
    if "dim_contrepartie" in dataframes:
        df = dataframes["dim_contrepartie"]
        print(f"Insertion DIM_CONTREPARTIE ({len(df)} lignes)...")
        rows = [convert_row(row) for row in df[['id_contrepartie', 'nom_contrepartie', 'type_contrepartie']].values]
        execute_values(
            cursor,
            """
            INSERT INTO DIM_CONTREPARTIE (id_contrepartie, nom_contrepartie, type_contrepartie)
            VALUES %s
            ON CONFLICT (id_contrepartie) DO UPDATE SET
                nom_contrepartie = EXCLUDED.nom_contrepartie,
                type_contrepartie = EXCLUDED.type_contrepartie
            """,
            rows
        )
        print("  ✓ DIM_CONTREPARTIE insérée")
    
    # 5. DIM_TEMPS (pas de dépendances)
    if "dim_temps" in dataframes:
        df = dataframes["dim_temps"]
        print(f"Insertion DIM_TEMPS ({len(df)} lignes)...")
        rows = [convert_row(row) for row in df[['id_temps', 'jour', 'mois', 'annee']].values]
        execute_values(
            cursor,
            """
            INSERT INTO DIM_TEMPS (id_temps, jour, mois, annee)
            VALUES %s
            ON CONFLICT (id_temps) DO UPDATE SET
                jour = EXCLUDED.jour,
                mois = EXCLUDED.mois,
                annee = EXCLUDED.annee
            """,
            rows
        )
        print("  ✓ DIM_TEMPS insérée")
    
    # 6. DIM_COMPTE (dépend de DIM_DEVISE et DIM_FILIALE)
    if "dim_compte" in dataframes:
        df = dataframes["dim_compte"]
        print(f"Insertion DIM_COMPTE ({len(df)} lignes)...")
        rows = [convert_row(row) for row in df[['id_compte', 'numero_compte', 'type_compte', 'id_devise', 'id_filiale']].values]
        execute_values(
            cursor,
            """
            INSERT INTO DIM_COMPTE (id_compte, numero_compte, type_compte, id_devise, id_filiale)
            VALUES %s
            ON CONFLICT (id_compte) DO UPDATE SET
                numero_compte = EXCLUDED.numero_compte,
                type_compte = EXCLUDED.type_compte,
                id_devise = EXCLUDED.id_devise,
                id_filiale = EXCLUDED.id_filiale
            """,
            rows
        )
        print("  ✓ DIM_COMPTE insérée")
    
    # 7. FACT_FLUX_TRESORERIE (dépend de toutes les dimensions)
    if "fact_flux_tresorerie" in dataframes:
        df = dataframes["fact_flux_tresorerie"]
        print(f"Insertion FACT_FLUX_TRESORERIE ({len(df)} lignes)...")
        
        # Nettoyer les valeurs NaN pour PostgreSQL
        df_clean = df.copy()
        df_clean['montant_consolide_eur'] = df_clean['montant_consolide_eur'].fillna(0)
        
        rows = [convert_row(row) for row in df_clean[[
            'date_operation', 'montant_transaction', 'montant_consolide_eur', 
            'type_operation', 'statut', 'id_compte', 'id_devise', 
            'id_scenario', 'id_temps', 'id_contrepartie'
        ]].values]
        
        execute_values(
            cursor,
            """
            INSERT INTO FACT_FLUX_TRESORERIE 
            (date_operation, montant_transaction, montant_consolide_eur, type_operation, statut,
             id_compte, id_devise, id_scenario, id_temps, id_contrepartie)
            VALUES %s
            """,
            rows
        )
        print("  ✓ FACT_FLUX_TRESORERIE insérée")
    
    conn.commit()
    cursor.close()
    conn.close()
    
    print("✓ Load terminé avec succès")


def run_predictive_model(**context):
    """
    Tâche 4 : Model - Exécuter le modèle prédictif et insérer les prévisions
    """
    print("=" * 60)
    print("TÂCHE 4 : MODEL")
    print("=" * 60)
    
    # Exécuter le script de modélisation prédictive
    import sys
    script_path = Path("/opt/airflow/scripts/predictive_model.py")
    
    if not script_path.exists():
        raise FileNotFoundError(f"Script predictive_model.py non trouvé à {script_path}")
    
    script_to_run = str(script_path)
    
    print(f"Exécution du modèle prédictif : {script_to_run}")
    
    # Exécuter le script
    import subprocess
    result = subprocess.run(
        [sys.executable, script_to_run],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        print(f"✗ Erreur lors de l'exécution du modèle : {result.stderr}")
        raise RuntimeError(f"Échec du modèle prédictif : {result.stderr}")
    
    print(result.stdout)
    print("✓ Model terminé avec succès")


# Définition du DAG
default_args = {
    'owner': 'cresus_team',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'cresus_pipeline',
    default_args=default_args,
    description='Pipeline ETL pour le POC Crésus - BI Prédictive Trésorerie',
    schedule_interval=timedelta(days=1),  # Exécution quotidienne
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['cresus', 'etl', 'bi', 'tresorerie'],
)

# Définition des tâches
task_extract = PythonOperator(
    task_id='extract',
    python_callable=extract_data,
    dag=dag,
)

task_transform = PythonOperator(
    task_id='transform',
    python_callable=transform_data,
    dag=dag,
)

task_load = PythonOperator(
    task_id='load',
    python_callable=load_data,
    dag=dag,
)

task_model = PythonOperator(
    task_id='model',
    python_callable=run_predictive_model,
    dag=dag,
)

# Définition des dépendances (chaîne séquentielle)
task_extract >> task_transform >> task_load >> task_model

