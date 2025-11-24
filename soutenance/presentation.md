---
marp: true
theme: gaia
class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.jpg')
style: |
  section {
    font-family: 'Arial', sans-serif;
    font-size: 24px;
  }
  h1 {
    color: #2c3e50;
  }
  h2 {
    color: #34495e;
  }
  strong {
    color: #e74c3c;
  }
---

# Projet Crésus
## BI Prédictive pour la Gestion de Trésorerie
### ZF Banque

###### Nolan Cacheux, Gaspard Crépin, Amine El-Bakali, Othmane Ettahri El Joti, Sacha Evain, Rémi Hage, Lucile Lorimier
---

# Sommaire

1. Contexte et Enjeux
2. Problématique
3. Solution Proposée
4. Architecture Technique
5. Modélisation des Données
6. Démonstration (Dashboards)
7. Conclusion

---

# 1. Contexte et Enjeux

### Le client : ZF Banque
- Acteur international (Europe, Afrique, Amérique du Nord).
- 2800 agences, 5000 collaborateurs.
- Transformation stratégique initiée par la Direction Générale.

### Les Enjeux
- **Financier** : Optimiser le rendement des liquidités, réduire les coûts de financement.
- **Stratégique** : Doter la Direction Financière d'outils de pilotage et de simulation.
- **Opérationnel** : Automatiser les processus et fiabiliser les prévisions.

---

# 2. Problématique

> Comment l'analyse prédictive et la simulation peuvent-elles être des facteurs de gains dans la gestion de trésorerie d'une banque ?

### Constats actuels
- **Manque de visibilité** : Données hétérogènes et dispersées.
- **Difficulté d'anticipation** : Gestion multi-devises complexe, prévisions peu fiables.
- **Gestion des risques limitée** : Incapacité à simuler des scénarios de stress (taux, change).

---

# 3. Solution Proposée

Une plateforme centralisée de **Business Intelligence Prédictive**.

### Stack Technologique
- **Génération de données** : Scripts **Python** (Simulation réaliste de flux).
- **Stockage** : Base de données **PostgreSQL** (Centralisation).
- **Orchestration** : **Apache Airflow** (ETL, Pipelines de modélisation).
- **Restitution** : **Microsoft Power BI** (Tableaux de bord interactifs).

---

# 4. Architecture Technique

Le flux de données suit 4 étapes logiques :

1. **Sources** :
   - Données internes (Transactions générées par Python).
   - Données externes (Taux de change, marchés).

2. **Ingestion & Stockage** :
   - Centralisation dans **PostgreSQL**.
   - Historisation et structuration.

3. **Modélisation & Simulation** :
   - Pipelines **Airflow** pour l'ETL.
   - Calcul des prévisions et scénarios.

4. **Visualisation** :
   - **Power BI** connecté à la base de données.
   - Analyses "What-if" (Simulation).

---

# 5. Modélisation des Données

Architecture en **Schéma en Étoile** pour optimiser les performances BI.

### Table de Faits
- **FACT_FLUX_TRESORERIE** : Transactions, montants, statuts.

### Dimensions
- **DIM_TEMPS** : Analyse temporelle (Jour, Mois, Année).
- **DIM_FILIALE** : Vue par entité géographique.
- **DIM_DEVISE** : Gestion multi-devises.
- **DIM_COMPTE** : Détail des comptes bancaires.
- **DIM_SCENARIO** : Distinction Réalisé / Prévisionnel / Simulé.
- **DIM_CONTREPARTIE** : Clients, Fournisseurs, Banques.

---

# 6. Démonstration - Vue d'ensemble

*(Insérer ici une capture du Dashboard Principal : Vue consolidée de la trésorerie groupe)*

Ce tableau de bord permet de visualiser :
- La position de cash actuelle par devise.
- L'évolution historique des flux.
- Les indicateurs clés de performance (KPIs).

---

# 6. Démonstration - Analyse Prévisionnelle

*(Insérer ici une capture du Dashboard Prévisionnel : Graphiques de projection à 30 jours)*

Fonctionnalités clés :
- Comparaison Réalisé vs Prévisionnel.
- Identification des pics de besoins de liquidité.
- Anticipation des excédents à placer.

---

# 6. Démonstration - Simulation & Scénarios

*(Insérer ici une capture du Dashboard Simulation : Paramètres de variation taux/change)*

Capacités de simulation ("What-if") :
- Impact d'une variation du taux de change EUR/USD.
- Simulation de stress tests (crise de liquidité).
- Aide à la décision pour la couverture de risque.

---

# 7. Conclusion

### Valeur Ajoutée du Projet Crésus
- **Pilotage proactif** : Passage d'une gestion réactive à une anticipation des besoins.
- **Optimisation financière** : Meilleure allocation des ressources et réduction des coûts.
- **Centralisation** : Une source de vérité unique pour toutes les filiales.

### Prochaines étapes
- Déploiement progressif aux autres filiales.
- Intégration de modèles de Machine Learning plus avancés.
- Industrialisation des pipelines de données.

---

# Merci de votre attention

**Avez-vous des questions ?**

