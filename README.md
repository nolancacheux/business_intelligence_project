# POC Crésus - BI Prédictive Trésorerie

## Vue d'ensemble

Ce projet est un Proof of Concept (POC) pour **Crésus**, une solution de Business Intelligence prédictive pour la gestion de trésorerie du groupe ZF Banque.

Le POC démontre la faisabilité d'une architecture complète d'ingestion, transformation, stockage et visualisation de données de trésorerie avec des capacités prédictives.

## Architecture Technique

**Stack technique imposée :**
- **Base de données** : PostgreSQL
- **Orchestration ETL** : Apache Airflow
- **Génération de données** : Python
- **Modélisation prédictive** : Python (scikit-learn - régression linéaire)
- **Visualisation** : Microsoft Power BI Desktop

**Flux de données :** 
1. `generate_data.py` → Génère les CSV sources
2. `load_data.py` → Charge les CSV dans PostgreSQL (ou via Airflow)
3. `predictive_model.py` → Génère les prévisions
4. Power BI → Visualise les données

## Structure du Projet

```
business_intelligence_project/
├── README.md                      # Ce fichier
├── requirements.txt               # Dépendances Python globales
├── docker-compose.yml             # Configuration Docker pour PostgreSQL
├── .gitignore                     # Fichiers à ignorer par Git
│
├── database/                      # Scripts de base de données
│   └── create_tables.sql          # Création du schéma en flocon
│
├── etl/                           # Scripts ETL
│   ├── generate_data.py          # Génération de données synthétiques
│   └── cresus_pipeline_dag.py     # DAG Airflow pour le pipeline ETL
│
├── scripts/                       # Scripts utilitaires
│   ├── load_data.py              # Chargement des CSV dans PostgreSQL
│   ├── predictive_model.py       # Modèle de régression linéaire
│   └── test_connection.py        # Test de connexion PostgreSQL
│
├── airflow/                       # Configuration Airflow
│   ├── requirements.txt           # Dépendances spécifiques Airflow
│   └── config/                    # Configuration Airflow (optionnel)
│
├── data/                          # Données
│   └── sources/                   # CSV générés par generate_data.py
│
├── powerbi/                       # Fichiers Power BI
│   ├── Cresus_POC.pbit            # Template Power BI (JSON)
│   └── POWER_BI_INSTRUCTIONS.md   # Instructions pour créer le rapport
│
└── docs/                          # Documentation
    ├── ARCHITECTURE.md            # Architecture détaillée
    ├── SETUP.md                   # Guide de démarrage rapide
    ├── AIRFLOW_SETUP.md           # Configuration Airflow
    └── DEPLOIEMENT.md             # Options de déploiement
```

## Plan de Développement

### Étape 1 : Structure Base de Données PostgreSQL

**Fichier :** `database/create_tables.sql`

Créer le schéma en flocon avec :
- **Table de faits :** `FACT_FLUX_TRESORERIE` (id_flux, date_operation, montant_transaction, montant_consolide_eur, type_operation, statut, clés étrangères vers dimensions)
- **Dimensions :**
  - `DIM_TEMPS` (id_temps, jour, mois, annee)
  - `DIM_SCENARIO` (id_scenario, nom_scenario, description)
  - `DIM_DEVISE` (id_devise, code_iso, libelle_devise)
  - `DIM_FILIALE` (id_filiale, nom_filiale, pays, region)
  - `DIM_COMPTE` (id_compte, numero_compte, type_compte, FK vers DIM_DEVISE et DIM_FILIALE)
  - `DIM_CONTREPARTIE` (id_contrepartie, nom_contrepartie, type_contrepartie)
- **Contraintes :** Clés étrangères de FACT_FLUX_TRESORERIE vers toutes les dimensions

### Étape 2 : Génération Données Sources

**Fichier :** `etl/generate_data.py`

Générer des CSV synthétiques réalistes pour 2-3 ans d'historique :

**Dimensions (CSV) :**
- `dim_filiale.csv` : Filiales ZF Banque (France, Allemagne, UK, etc.) avec pays/région
- `dim_devise.csv` : EUR, USD, GBP, CHF minimum
- `dim_scenario.csv` : "Réalisé", "Prévisionnel", "Simulation Taux +1%"
- `dim_contrepartie.csv` : Clients, fournisseurs, banques partenaires
- `dim_compte.csv` : Comptes liés aux filiales et devises
- `dim_temps.csv` : Calendrier sur 2-3 ans

**Faits (CSV) :**
- `fact_flux_tresorerie.csv` : Transactions avec type_operation (Virement émis/reçu, Prêt, etc.), statut (Réalisé/Prévisionnel), montants cohérents avec les dimensions

**Données externes :**
- `taux_de_change.csv` : Historique taux de change (date, code_iso_source, code_iso_cible, taux)

### Étape 3 : Chargement des Données dans PostgreSQL

**Fichier :** `scripts/load_data.py`

Script simple pour charger les CSV dans PostgreSQL :
- Lecture des fichiers CSV depuis `data/sources/`
- Application des transformations de mapping (masquage comptes, normalisation, etc.)
- Insertion dans PostgreSQL dans l'ordre des dépendances
- Alternative simple au pipeline Airflow pour le POC

**Note :** Ce script peut être utilisé indépendamment ou remplacé par le pipeline Airflow en production.

### Étape 4 : Pipeline Airflow ETL + Modélisation

**Fichier :** `etl/cresus_pipeline_dag.py`

DAG Airflow avec 4 tâches séquentielles (alternative au script `load_data.py` pour la production) :

**Tâche 1 (Extract) :** Lire tous les CSV sources depuis le dossier `data/sources/`

**Tâche 2 (Transform) :** Appliquer les transformations de mapping :
- `date_operation` → format SQL DATE
- `montant` → nettoyage (suppression caractères non numériques)
- `type_operation` → normalisation minuscules
- `region` (DIM_FILIALE) → mapping automatique pays → région
- `numero_compte` → masquage partiel (ex: `FR76 **** **** **** 1234`)
- `type_contrepartie` → normalisation via dictionnaire
- `montant_consolide_eur` → calcul via taux_de_change.csv selon date_operation

**Tâche 3 (Load) :** Insertion dans PostgreSQL (dimensions d'abord, puis faits)

**Tâche 4 (Model) :**
- Script Python de régression linéaire sur `montant_transaction` par filiale/compte
- Prévisions à 30 jours
- Insertion dans `FACT_FLUX_TRESORERIE` avec `id_scenario` "Prévisionnel" et `statut` "Prévisionnel"

**Note :** Le script `scripts/predictive_model.py` peut également être exécuté indépendamment après le chargement des données.

### Étape 5 : Rapport Power BI

**Fichiers :**
- `powerbi/Cresus_POC.pbit` : Template Power BI (JSON) avec structure de connexion PostgreSQL
- `powerbi/POWER_BI_INSTRUCTIONS.md` : Instructions détaillées pour finaliser le rapport

**Modélisation :**
- Connexion PostgreSQL
- Relations en flocon (PK/FK) : FACT_FLUX_TRESORERIE → toutes les dimensions, DIM_COMPTE → DIM_FILIALE/DIM_DEVISE

**Visuels requis :**
1. **Trésorerie Historique :** Flux (`montant_consolide_eur`) par DIM_TEMPS, DIM_FILIALE (région/pays), type_operation
2. **Prévisions 30 jours :** Données où `statut = 'Prévisionnel'`
3. **Simulations What-If :**
   - Paramètre "Fluctuation taux EUR/USD" (ex: -5% à +5%)
   - Paramètre "Retard paiement clients" (ex: 0 à 30 jours)
   - Recalcul dynamique des prévisions/soldes consolidés

### Étape 6 : Documentation et Architecture

**Fichiers :**
- `docs/ARCHITECTURE.md` : Diagramme d'architecture (Mermaid) : `CSV sources → Airflow → PostgreSQL → Modèle prédictif → Power BI`
- `README.md` : Guide d'installation et d'utilisation du POC
- `requirements.txt` : Dépendances Python globales

## Installation

### Prérequis

1. **Docker** (pour PostgreSQL) ou PostgreSQL installé localement
2. **Python** (version 3.8 ou supérieure)
3. **Apache Airflow** (version 2.7 ou supérieure) - optionnel pour le POC
4. **Power BI Desktop** (pour la visualisation)

### Installation Rapide (Docker)

1. **Cloner ou télécharger le projet**

```bash
cd business_intelligence_project
```

2. **Créer un environnement virtuel Python**

```bash
python -m venv venv
source venv/bin/activate  # Sur Windows : venv\Scripts\activate
```

3. **Installer les dépendances**

```bash
pip install -r requirements.txt
```

4. **Démarrer PostgreSQL avec Docker**

```bash
docker-compose up -d postgres
```

Le script `database/create_tables.sql` sera automatiquement exécuté au démarrage.

5. **Générer les données sources**

```bash
python etl/generate_data.py
```

Les fichiers CSV seront générés dans `data/sources/`.

6. **Charger les données dans PostgreSQL**

```bash
python scripts/load_data.py
```

Ce script charge les CSV dans PostgreSQL avec toutes les transformations appliquées.

7. **Vérifier la connexion et les données**

```bash
python scripts/test_connection.py
```

Vous devriez voir le nombre de transactions chargées.

### Installation Manuelle (PostgreSQL Local)

1. Créer une base de données :

```sql
CREATE DATABASE cresus_db;
```

2. Exécuter le script de création des tables :

```bash
psql -U postgres -d cresus_db -f database/create_tables.sql
```

## Scripts et leur Rôle

### Scripts de Génération et Chargement

**`etl/generate_data.py`** : Génère les fichiers CSV sources
- Crée les fichiers CSV dans `data/sources/`
- Génère 2-3 ans d'historique synthétique
- À exécuter une seule fois (ou pour régénérer les données)

**`scripts/load_data.py`** : Charge les CSV dans PostgreSQL
- Lit les fichiers CSV depuis `data/sources/`
- Applique les transformations de mapping
- Insère les données dans PostgreSQL
- Alternative simple au pipeline Airflow pour le POC

**`scripts/predictive_model.py`** : Génère les prévisions
- Analyse les données historiques
- Entraîne un modèle de régression linéaire
- Génère des prévisions à 30 jours
- Insère les prévisions dans `FACT_FLUX_TRESORERIE`

### Flux Complet Recommandé

```bash
# 1. Générer les données CSV (une seule fois)
python etl/generate_data.py

# 2. Charger les données dans PostgreSQL
python scripts/load_data.py

# 3. Générer les prévisions (optionnel)
python scripts/predictive_model.py

# 4. Visualiser dans Power BI
# Suivre powerbi/POWER_BI_INSTRUCTIONS.md
```

## Utilisation

### 1. Exécution du pipeline ETL

#### Option A : Via Apache Airflow (recommandé pour production)

1. Installer Airflow (voir [documentation officielle](https://airflow.apache.org/docs/apache-airflow/stable/start.html))

2. Configurer les variables d'environnement :

```bash
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_DB=cresus_db
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
```

3. Copier le DAG dans le répertoire des DAGs Airflow :

```bash
cp etl/cresus_pipeline_dag.py $AIRFLOW_HOME/dags/
cp -r scripts $AIRFLOW_HOME/
cp -r data $AIRFLOW_HOME/
```

4. Démarrer Airflow :

```bash
airflow webserver --port 8080
airflow scheduler
```

5. Accéder à l'interface web : http://localhost:8080

6. Activer le DAG `cresus_pipeline` dans l'interface web

#### Option B : Scripts Python simples (recommandé pour le POC)

Pour un chargement rapide sans Airflow :

```bash
# 1. Générer les données CSV (si pas déjà fait)
python etl/generate_data.py

# 2. Charger les données dans PostgreSQL
python scripts/load_data.py

# 3. Vérifier le chargement
python scripts/test_connection.py
```

Le script `scripts/load_data.py` applique automatiquement toutes les transformations nécessaires (masquage comptes, normalisation, calcul montant_consolide_eur, etc.).

### 2. Visualisation dans Power BI

Suivre les instructions détaillées dans `powerbi/POWER_BI_INSTRUCTIONS.md` pour :
- Se connecter à PostgreSQL
- Créer le modèle de données en flocon
- Construire les visuels (historique, prévisions, simulations What-If)

## Modèle de Données

Le modèle est en **flocon (snowflake schema)** avec :

- **1 table de faits** : `FACT_FLUX_TRESORERIE`
- **6 tables de dimensions** :
  - `DIM_TEMPS` (dimension temporelle)
  - `DIM_SCENARIO` (scénarios : Réalisé, Prévisionnel, Simulations)
  - `DIM_DEVISE` (devises : EUR, USD, GBP, CHF)
  - `DIM_FILIALE` (filiales du groupe)
  - `DIM_COMPTE` (comptes bancaires)
  - `DIM_CONTREPARTIE` (contreparties : clients, fournisseurs, etc.)

Voir `database/create_tables.sql` pour la structure complète.

## Transformations Appliquées

Le pipeline applique les transformations suivantes :

1. **date_operation** : Conversion au format SQL DATE
2. **montant_transaction** : Nettoyage (suppression caractères non numériques)
3. **type_operation** : Normalisation en minuscules
4. **region** (DIM_FILIALE) : Ajout automatique via mapping pays → région
5. **numero_compte** : Masquage partiel (ex: `FR76 **** **** **** 1234`)
6. **type_contrepartie** : Normalisation via dictionnaire
7. **montant_consolide_eur** : Calcul via taux de change selon date_operation

## Modèle Prédictif

Le modèle utilise une **régression linéaire** (scikit-learn) pour générer des prévisions de trésorerie à 30 jours.

**Features utilisées :**
- Jour de la semaine
- Jour du mois
- Mois
- Jours depuis le début
- Moyenne mobile sur 7 jours

Les prévisions sont stockées dans `FACT_FLUX_TRESORERIE` avec `statut = "Prévisionnel"` et `id_scenario = 2`.

## Configuration

### Variables d'environnement

```bash
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=cresus_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=votre_mot_de_passe
```

### Configuration Docker

Le fichier `docker-compose.yml` configure PostgreSQL avec :
- Port : 5432
- Base de données : cresus_db
- Utilisateur : postgres
- Mot de passe : postgres (à changer en production)

## Déploiement en Production

### Configuration Actuelle : LOCAL

Actuellement, tout est configuré pour fonctionner **localement** sur votre machine :

- **PostgreSQL** : Conteneur Docker sur `localhost:5432`
- **Données** : Fichiers CSV dans `data/sources/`
- **Scripts Python** : Exécution locale
- **Power BI** : Se connecte à PostgreSQL local

**Avantages :**
- Rapide à mettre en place
- Pas de coûts cloud
- Idéal pour le POC et les tests
- Contrôle total sur l'environnement

### Options pour Déploiement Cloud/Production

Voir `docs/DEPLOIEMENT.md` pour les options complètes de déploiement :

1. **PostgreSQL Cloud** (Azure Database, AWS RDS, etc.)
2. **Déploiement Complet sur Azure** (Azure Data Factory, Azure ML, Power BI Service)
3. **Docker Compose sur Serveur** (même configuration sur serveur Linux)

### Migration vers le Cloud

Pour migrer vers Azure ou un autre cloud :

1. **Créer une instance PostgreSQL cloud**
2. **Modifier les variables d'environnement** pour pointer vers le serveur cloud
3. **Adapter les chemins dans les scripts** si nécessaire
4. **Configurer Power BI** pour se connecter au serveur cloud

**Note importante :** Azure Database for PostgreSQL n'est pas gratuit (~15-40 USD/mois minimum). La solution locale reste recommandée pour le POC.

## Dépannage

### Erreur de connexion PostgreSQL

Vérifier que PostgreSQL est démarré :

```bash
docker ps
docker exec cresus_postgres psql -U postgres -d cresus_db -c "\dt"
```

### Erreur Airflow "File not found"

Vérifier que les fichiers CSV sont dans le bon répertoire et que les chemins dans le DAG sont corrects.

### Erreur Power BI "Cannot connect"

Vérifier que PostgreSQL accepte les connexions externes et que le pare-feu autorise le port 5432.

## Livrables

- `database/create_tables.sql` : Structure de base de données
- `etl/generate_data.py` : Génération de données synthétiques
- `etl/cresus_pipeline_dag.py` : Pipeline Airflow ETL
- `scripts/predictive_model.py` : Modèle prédictif
- `powerbi/Cresus_POC.pbit` : Template Power BI
- `powerbi/POWER_BI_INSTRUCTIONS.md` : Instructions Power BI
- Documentation complète dans `docs/`

## Prochaines Étapes (Phase 2)

- Amélioration du modèle prédictif (SARIMA, LSTM)
- Ajout de nouvelles sources de données
- Automatisation complète du déploiement
- Intégration avec Azure ML (production)

## Support

Pour toute question ou problème, consulter :
- `docs/ARCHITECTURE.md` : Architecture détaillée
- `docs/SETUP.md` : Guide de démarrage rapide
- `docs/AIRFLOW_SETUP.md` : Configuration Airflow
- `powerbi/POWER_BI_INSTRUCTIONS.md` : Guide Power BI
- `docs/DEPLOIEMENT.md` : Options de déploiement

## Licence

Nolan CACHEUX
