# Architecture du POC Crésus

## Vue d'ensemble

Architecture complète de BI prédictive pour la gestion de trésorerie avec :
- Génération de données synthétiques
- Pipeline ETL orchestré par Airflow
- Modèle prédictif (régression linéaire)
- Visualisation Power BI

## Flux de Données

```
CSV Sources → Airflow ETL → PostgreSQL → Modèle Prédictif → Power BI
```

### 1. Génération des Données

**Script :** `etl/generate_data.py`

Génère les fichiers CSV dans `data/sources/` :
- Dimensions (filiales, devises, scénarios, contreparties, comptes, temps)
- Taux de change historiques
- Transactions de trésorerie (2-3 ans)

### 2. Pipeline ETL

**Option A : Script simple** (`scripts/load_data.py`)
- Lecture CSV
- Transformations (masquage, normalisation, calcul montant_consolide_eur)
- Insertion PostgreSQL

**Option B : Airflow** (`dags/cresus_pipeline_dag.py`)
- 4 tâches séquentielles : Extract → Transform → Load → Model
- Planification automatique
- Gestion des erreurs et retry

### 3. Modèle Prédictif

**Script :** `scripts/predictive_model.py`

- Analyse des données historiques
- Régression linéaire par compte
- Prévisions à 30 jours
- Insertion dans `FACT_FLUX_TRESORERIE` avec `statut = "Prévisionnel"`

### 4. Visualisation

**Power BI Desktop** connecté à PostgreSQL
- Modèle en flocon (snowflake schema)
- Visualisations historiques, prévisions, simulations What-If

## Modèle de Données

**Schéma en flocon :**
- 1 table de faits : `FACT_FLUX_TRESORERIE`
- 6 dimensions : `DIM_TEMPS`, `DIM_SCENARIO`, `DIM_DEVISE`, `DIM_FILIALE`, `DIM_COMPTE`, `DIM_CONTREPARTIE`

Voir `database/create_tables.sql` pour la structure complète.

## Transformations Appliquées

1. Masquage partiel des numéros de compte
2. Normalisation des types de contrepartie
3. Mapping automatique pays → région
4. Calcul `montant_consolide_eur` via taux de change
5. Nettoyage et normalisation des données

## Technologies

- **PostgreSQL** : Base de données relationnelle
- **Apache Airflow** : Orchestration ETL
- **Python** : Scripts de traitement et modélisation
- **scikit-learn** : Modèle de régression linéaire
- **Power BI** : Visualisation et reporting

## Déploiement

**Local (POC) :**
- PostgreSQL : Docker
- Airflow : Docker Compose
- Scripts Python : Exécution locale

**Production :**
Voir `docs/DEPLOIEMENT.md` pour les options cloud (Azure, AWS, etc.)
