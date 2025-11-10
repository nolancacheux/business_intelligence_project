# Configuration Airflow - POC Crésus

## Démarrage avec Docker

```bash
docker-compose -f docker-compose-airflow.yml up -d
```

Vérifier que tous les services sont démarrés :
```bash
docker ps
```

## Accès à l'Interface Web

- URL : http://localhost:8080
- Identifiants : `airflow` / `airflow`

## Utilisation du DAG

Le DAG `cresus_pipeline` est automatiquement détecté dans `dags/cresus_pipeline_dag.py`.

**Activer le DAG :**
- Dans l'interface web, toggle ON/OFF sur le DAG

**Exécuter manuellement :**
- Cliquer sur le DAG → "Play" → "Trigger DAG"

**Planification :**
- Par défaut : quotidienne à 14:25 UTC
- Modifiable dans le DAG

## Structure du Pipeline

4 tâches séquentielles :
1. **extract** : Lit les CSV depuis `/opt/airflow/data/sources/`
2. **transform** : Applique les transformations de mapping
3. **load** : Insère dans PostgreSQL
4. **model** : Génère les prévisions et les insère

## Commandes Utiles

**Voir les logs :**
```bash
docker logs cresus_airflow_scheduler
docker logs cresus_airflow_webserver
```

**Arrêter Airflow :**
```bash
docker-compose -f docker-compose-airflow.yml down
```

**Redémarrer :**
```bash
docker-compose -f docker-compose-airflow.yml restart
```

## Configuration

Les variables d'environnement sont dans `.env-airflow` :
- PostgreSQL principal : `host.docker.internal:5432`
- Base de données Airflow : PostgreSQL interne
- Executor : CeleryExecutor avec Redis

## Dépannage

**DAG non visible :** Vérifier que le fichier est dans `dags/` et que le scheduler est démarré.

**Tâches en échec :** Vérifier les logs dans l'interface web ou via `docker logs`.

**Scheduler unhealthy :** Vérifier que Redis et PostgreSQL Airflow sont démarrés.
