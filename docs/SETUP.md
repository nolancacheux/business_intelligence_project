# Guide de Démarrage Rapide

## Installation Initiale

1. **Cloner le projet**
2. **Créer l'environnement virtuel Python** :
   ```bash
   python -m venv venv
   source venv/bin/activate  # Windows : venv\Scripts\activate
   ```
3. **Installer les dépendances** :
   ```bash
   pip install -r requirements.txt
   ```

## Démarrage PostgreSQL

```bash
docker-compose up -d postgres
```

Vérifier :
```bash
docker exec cresus_postgres psql -U postgres -d cresus_db -c "\dt"
```

## Génération et Chargement des Données

**Générer les CSV :**
```bash
python etl/generate_data.py
```

**Charger dans PostgreSQL :**
```bash
python scripts/load_data.py
```

**Vérifier :**
```bash
python scripts/test_connection.py
```

## Générer les Prévisions

```bash
python scripts/predictive_model.py
```

## Utiliser Airflow (Optionnel)

Voir `docs/AIRFLOW_SETUP.md` pour la configuration Airflow avec Docker.

## Power BI

Voir `powerbi/POWER_BI_INSTRUCTIONS.md` pour créer le rapport.

## Variables d'Environnement

Par défaut, les scripts utilisent :
- `POSTGRES_HOST=localhost`
- `POSTGRES_PORT=5432`
- `POSTGRES_DB=cresus_db`
- `POSTGRES_USER=postgres`
- `POSTGRES_PASSWORD=postgres`

Modifier si nécessaire dans les scripts ou via variables d'environnement.
