# Options de Déploiement - POC Crésus

## Configuration Actuelle : LOCAL

Actuellement, tout est configuré pour fonctionner **localement** sur votre machine :

### Ce qui tourne en local :

1. **PostgreSQL** : Conteneur Docker sur `localhost:5432`
   - Accessible uniquement depuis votre machine
   - Port 5432 mappé localement

2. **Données** : Fichiers CSV dans `data/sources/`
   - Stockage local sur votre disque

3. **Scripts Python** : Exécution locale
   - Pas de serveur distant

4. **Power BI** : Se connectera à PostgreSQL local
   - Nécessite que PostgreSQL soit accessible depuis Power BI Desktop

### Avantages du déploiement local :
- Rapide à mettre en place
- Pas de coûts cloud
- Idéal pour le POC et les tests
- Contrôle total sur l'environnement

### Inconvénients :
- Non accessible depuis d'autres machines
- Nécessite que votre machine soit allumée
- Pas de partage facile avec d'autres utilisateurs

---

## Options pour Déploiement Cloud/Production

Si vous souhaitez déployer ailleurs, voici les options :

### Option 1 : PostgreSQL Cloud (Azure Database, AWS RDS, etc.)

**Modifier la connexion dans les scripts :**

```python
# Au lieu de localhost
DB_CONFIG = {
    "host": "votre-serveur-postgres.cloud.com",  # Adresse du serveur cloud
    "port": "5432",
    "database": "cresus_db",
    "user": "votre_user",
    "password": "votre_password"
}
```

**Services recommandés :**
- **Azure Database for PostgreSQL**
- **AWS RDS PostgreSQL**
- **Google Cloud SQL**
- **Heroku Postgres**

### Option 2 : Déploiement Complet sur Azure

**Architecture cloud proposée :**

```
Azure Storage (CSV) 
    ↓
Azure Data Factory / Airflow sur Azure
    ↓
Azure Database for PostgreSQL
    ↓
Azure Machine Learning (modèle prédictif)
    ↓
Power BI Service (cloud)
```

**Composants Azure :**
- **Azure Storage** : Stockage des fichiers CSV
- **Azure Data Factory** : Orchestration ETL (alternative à Airflow)
- **Azure Database for PostgreSQL** : Base de données managée
- **Azure Machine Learning** : Modèle prédictif
- **Power BI Service** : Visualisation cloud (partageable)

### Option 3 : Docker Compose sur Serveur

Déployer le même `docker-compose.yml` sur un serveur Linux :

```bash
# Sur le serveur
git clone <votre-repo>
cd business_intelligence_project
docker-compose up -d
```

Puis modifier les connexions pour pointer vers l'IP du serveur.

---

## Comment Changer la Configuration

### Pour utiliser un PostgreSQL distant :

1. **Modifier les variables d'environnement :**

```bash
# Windows
set POSTGRES_HOST=votre-serveur.cloud.com
set POSTGRES_PORT=5432
set POSTGRES_DB=cresus_db
set POSTGRES_USER=votre_user
set POSTGRES_PASSWORD=votre_password
```

2. **Ou modifier directement dans les scripts Python :**

Dans `cresus_pipeline_dag.py` et `scripts/predictive_model.py`, changer :

```python
DB_CONFIG = {
    "host": "votre-serveur.cloud.com",  # Au lieu de "localhost"
    # ... reste identique
}
```

3. **Pour Power BI :**

Dans Power BI Desktop, lors de la connexion PostgreSQL, entrer :
- **Serveur** : `votre-serveur.cloud.com:5432`
- **Base de données** : `cresus_db`
- **Identifiants** : Vos identifiants cloud

---

## Comparaison Local vs Cloud

| Aspect | Local (Actuel) | Cloud |
|--------|----------------|-------|
| **Coût** | Gratuit | Payant (selon usage) |
| **Accessibilité** | Machine locale uniquement | Accessible partout |
| **Partage** | Difficile | Facile (Power BI Service) |
| **Scalabilité** | Limitée | Élasticité |
| **Maintenance** | Vous gérez | Géré par le provider |
| **Sécurité** | Votre responsabilité | Provider gère la sécurité |
| **Idéal pour** | POC, développement | Production, équipe |

---

## Recommandation

**Pour le POC actuel :** 
- Garder en local (configuration actuelle)
- Tester et valider le concept
- Développer les fonctionnalités

**Pour la production (Phase 2) :**
- Migrer vers Azure/AWS
- Utiliser Power BI Service pour le partage
- Automatiser le déploiement (CI/CD)

---

## Migration vers le Cloud (quand vous serez prêt)

Si vous souhaitez migrer plus tard, vous pouvez :
1. Créer les scripts de migration
2. Configurer Azure/AWS
3. Adapter le code pour le cloud
4. Mettre en place l'automatisation

Pour l'instant, la configuration locale est parfaite pour le POC.

