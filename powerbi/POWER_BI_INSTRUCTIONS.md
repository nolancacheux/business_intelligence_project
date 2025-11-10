# Guide Power BI - POC Crésus

## Connexion à PostgreSQL

1. Ouvrir Power BI Desktop
2. **Obtenir des données** → **Base de données** → **Base de données PostgreSQL**
3. Paramètres :
   - Serveur : `localhost`
   - Base de données : `cresus_db`
   - Utilisateur : `postgres`
   - Mot de passe : `postgres`
4. Sélectionner les 7 tables et charger

## Modélisation

Les relations sont détectées automatiquement. Vérifier dans la vue **Modèle** :
- `FACT_FLUX_TRESORERIE` → toutes les dimensions (via id_compte, id_devise, etc.)
- `DIM_COMPTE` → `DIM_FILIALE` et `DIM_DEVISE`

**Important :** Les tables sont nommées `'public fact_flux_tresorerie'` (avec préfixe `public` et minuscules).

## Mesures DAX Essentielles

Créer ces mesures dans `public fact_flux_tresorerie` :

**Trésorerie Totale :**
```dax
Trésorerie Totale = SUM('public fact_flux_tresorerie'[montant_consolide_eur])
```

**Trésorerie Réalisée :**
```dax
Trésorerie Réalisée = CALCULATE([Trésorerie Totale], 'public fact_flux_tresorerie'[statut] = "Réalisé")
```

**Trésorerie Prévisionnelle :**
```dax
Trésorerie Prévisionnelle = CALCULATE([Trésorerie Totale], 'public fact_flux_tresorerie'[statut] = "Prévisionnel")
```

## Visualisations Recommandées

### Page 1 : Trésorerie Historique
- Graphique en colonnes : Trésorerie Réalisée par mois/filiale
- Graphique en secteurs : Répartition par type d'opération
- Carte KPI : Trésorerie Totale

### Page 2 : Prévisions
- Graphique en courbes : Prévisions 30 jours (filtre statut = "Prévisionnel")
- Graphique en colonnes : Prévisions par filiale

### Page 3 : Simulations What-If
- Paramètre "Fluctuation Taux EUR/USD" (-5% à +5%)
- Paramètre "Retard Paiement" (0 à 30 jours)
- Mesures calculées dynamiques selon les paramètres

## Actualisation des Données

**Actualiser** dans Power BI Desktop après chaque exécution du pipeline Airflow.

## Notes

- Les prévisions ont `statut = "Prévisionnel"` et `id_scenario = 2`
- Les simulations What-If sont calculées à la volée dans Power BI
- Sauvegarder le rapport en `.pbix` pour partager avec l'équipe
