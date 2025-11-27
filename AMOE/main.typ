// ═══════════════════════════════════════════════════════════════════════════
// CONFIGURATION DU DOCUMENT
// ═══════════════════════════════════════════════════════════════════════════

#set document(
  title: "POC - BI Prédictive Finance",
  author: "Projet Crésus"
)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: rgb("#64748b"))
      #grid(
        columns: (1fr, 1fr),
        align(left)[_Projet Crésus_],
        align(right)[Spécifications Techniques AMOE]
      )
      #line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0"))
    ]
  },
  footer: context {
    set text(size: 9pt, fill: rgb("#64748b"))
    line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0"))
    v(0.3em)
    grid(
      columns: (1fr, 1fr),
      align(left)[ZF Banque – Confidentiel],
      align(right)[#counter(page).display("1 / 1", both: true)]
    )
  }
)

#set text(
  font: "Segoe UI",
  size: 11pt,
  lang: "fr"
)

#set par(
  justify: true,
  leading: 0.8em
)

#set heading(numbering: "1.1.")

// Style des titres
#show heading.where(level: 1): it => {
  v(1.5em)
  block(
    width: 100%,
    below: 1em,
    {
      set text(size: 16pt, weight: "bold", fill: rgb("#1e3a5f"))
      upper(it.body)
      v(0.3em)
      line(length: 100%, stroke: 2pt + rgb("#2563eb"))
    }
  )
}

#show heading.where(level: 2): it => {
  v(1em)
  block(
    below: 0.8em,
    {
      set text(size: 13pt, weight: "bold", fill: rgb("#1e40af"))
      it.body
    }
  )
}

#show heading.where(level: 3): it => {
  v(0.8em)
  block(
    below: 0.6em,
    {
      set text(size: 11pt, weight: "bold", fill: rgb("#334155"))
      it.body
    }
  )
}

#show heading.where(level: 4): it => {
  v(0.6em)
  block(
    below: 0.5em,
    {
      set text(size: 11pt, weight: "bold", fill: rgb("#475569"))
      it.body
    }
  )
}

// Style des liens
#show link: set text(fill: rgb("#2563eb"))
#show link: underline

// Style des listes
#set list(marker: ([•], [◦], [–]))
#set enum(numbering: "1.a.i.")

// Style des tableaux
#set table(
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 8pt,
  fill: (_, row) => if row == 0 { rgb("#f1f5f9") } else { none }
)

// Style des citations
#show quote: it => {
  block(
    width: 100%,
    inset: (left: 1em, y: 0.8em),
    stroke: (left: 3pt + rgb("#2563eb")),
    fill: rgb("#f8fafc"),
    {
      set text(style: "italic", fill: rgb("#475569"))
      it.body
    }
  )
}

// ═══════════════════════════════════════════════════════════════════════════
// PAGE DE TITRE
// ═══════════════════════════════════════════════════════════════════════════

#page(header: none, footer: none)[
  #v(3cm)
  
  #align(center)[
    #block(
      width: 100%,
      inset: 2em,
      {
        text(size: 12pt, fill: rgb("#64748b"), weight: "medium")[PROJET CRÉSUS]
        v(0.5em)
        line(length: 40%, stroke: 1pt + rgb("#2563eb"))
        v(1em)
        text(size: 28pt, weight: "bold", fill: rgb("#1e3a5f"))[
          POC Spécifications Techniques
        ]
        v(0.3em)
        text(size: 18pt, weight: "medium", fill: rgb("#334155"))[
          BI Prédictive Finance
        ]
        v(1.5em)
        line(length: 40%, stroke: 1pt + rgb("#2563eb"))
      }
    )
  ]
  
  #v(2cm)
  
  #align(center)[
    #block(
      width: 80%,
      inset: 1.5em,
      stroke: 1pt + rgb("#e2e8f0"),
      radius: 8pt,
      fill: rgb("#f8fafc"),
      {
        set text(size: 12pt, style: "italic", fill: rgb("#475569"))
        [« Comment l'analyse prédictive et la simulation peuvent-ils être des facteurs de gains dans la gestion de trésorerie d'une banque ? »]
      }
    )
  ]
  
  #v(1fr)
  
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 2em,
      [
        #set text(size: 10pt, fill: rgb("#64748b"))
        *Commanditaire* \
        ZF Banque \
        Direction des Systèmes d'Information
      ],
      [
        #set text(size: 10pt, fill: rgb("#64748b"))
        *Document* \
        Spécifications Techniques AMOE \
        Proof of Concept
      ]
    )
  ]
  
  #v(2cm)
]

// ═══════════════════════════════════════════════════════════════════════════
// TABLE DES MATIÈRES
// ═══════════════════════════════════════════════════════════════════════════

#page[
  #heading(level: 1, numbering: none)[Sommaire]
  #v(1em)
  #outline(
    title: none,
    indent: 1.5em,
    depth: 3
  )
]

// ═══════════════════════════════════════════════════════════════════════════
// CONTENU DU DOCUMENT
// ═══════════════════════════════════════════════════════════════════════════

= Introduction
<introduction>

== But du document
<but-du-document>

#quote[
  Cette fiche a pour but de présenter les spécifications techniques du Proof of Concept (POC) pour le projet "Crésus". Elle détaille l'architecture, les technologies et la structure des données qui seront mises en œuvre pour démontrer la faisabilité et la valeur d'une solution de BI prédictive pour la gestion de trésorerie du groupe ZF Banque.

  Plus concrètement, le document rassemble les livrables clés du POC, à savoir :
]

- Les fichiers sources utilisés
- L'architecture technique détaillée de la solution
- Le dictionnaire de données (KPI..)
- Les Modèles Conceptuel et Logique de Données (MCD / MDL)
- Le mapping de données.

= Spécifications techniques
<specifications-techniques>

== Solutions choisies
<solutions-choisies>

#block(
  width: 100%,
  inset: 1em,
  fill: rgb("#f8fafc"),
  radius: 4pt,
  stroke: 1pt + rgb("#e2e8f0"),
  [
    - *Base de données :* PostgreSQL
    - *Orchestrateur de flux :* Apache Airflow
    - *Modélisation et génération de données :* Scripts Python
    - *Data Visualisation et Simulation :* Microsoft Power BI Desktop
  ]
)

== Architecture technique
<architecture-technique>

L'architecture proposée suit un flux en quatre étapes :

+ *Sources de données :* Génération de données synthétiques (flux de trésorerie) via un script Python et intégration de données de marché externes (ex: taux de change via fichiers CSV).

+ *Ingestion & stockage :* Centralisation des données brutes et structurées dans une base de données PostgreSQL.

+ *Modélisation & simulation :* Orchestration par Apache Airflow de pipelines (DAGs) pour extraire, transformer les données, entraîner les modèles prédictifs et stocker les résultats (prévisions, simulations) dans PostgreSQL.

+ *Restitution & utilisation :* Connexion de Power BI à PostgreSQL pour visualiser les données historiques, les prévisions et permettre aux utilisateurs de lancer des simulations interactives (scénarios "what-if").

== Fichiers sources
<fichiers-sources>

Les fichiers sources constituent le point d'entrée principal du projet. Ils rassemblent l'ensemble des données nécessaires à la mise en œuvre de la solution de BI prédictive appliquée à la gestion de la trésorerie.

Ces données proviennent à la fois de sources internes, correspondant aux opérations financières du groupe, et de sources externes, issues des marchés monétaires et financiers.

Deux types de données sont exploités :

- *Les flux de trésorerie* (interne), représentant les opérations financières réalisées par les filiales du groupe.

- *Les cours de change des devises* (externe), permettant de prendre en compte les variations de taux dans les analyses et les simulations de trésorerie.

L'ensemble des fichiers sources a été généré ou importé sous format CSV. Les jeux de données internes ont été produits à l'aide d'un script Python simulant des transactions financières réalistes, tandis que les données externes proviennent de fichiers de marché contenant l'historique des taux de change.

Ces fichiers constituent la première étape du flux de traitement des données. Ils sont ensuite intégrés dans la base de données PostgreSQL, structurés selon le modèle de données défini, documentés dans le dictionnaire de données, puis mappés vers les différentes tables cibles utilisées pour les analyses et visualisations. Cette chaîne assure la cohérence, la traçabilité et la fiabilité des informations exploitées dans l'outil Power BI.

== Base de données
<base-de-données>

La base de données, gérée sous PostgreSQL, a été choisie pour sa robustesse, sa flexibilité et ses capacités avancées en SQL. Elle centralisera l'ensemble des données du projet, qu'elles soient internes (générées) ou externes, et contiendra aussi bien les données brutes que les données préparées pour l'analyse, ainsi que les résultats des prévisions et des simulations. Sa structure est pensée pour garantir la cohérence, la traçabilité et la performance des requêtes effectuées, notamment depuis Power BI.

Ce choix s'explique par le fait que PostgreSQL est reconnu comme un standard de l'industrie, compatible avec de nombreux outils, ce qui en facilite l'intégration. C'est une base performante, capable de gérer la montée en charge et de traiter de grosses volumétries. En tant que base relationnelle, PostgreSQL permet de diviser les données en plusieurs tables et de les lier via des requêtes plus ou moins complexes. Enfin, sa compatibilité avec l'écosystème Python et sa gestion avancée des types JSON offrent la possibilité de stocker et manipuler des données semi-structurées si besoin.

=== Structure de la base

==== 1. Table de faits

#block(
  width: 100%,
  inset: 1em,
  fill: rgb("#eff6ff"),
  radius: 4pt,
  stroke: 1pt + rgb("#bfdbfe"),
  [
    *FACT_FLUX_TRESORERIE* — Contient l'ensemble des transactions financières.

    *Champs principaux :*
    - id_flux (clé primaire)
    - montant
    - date_operation
    - type_operation
    - statut
    - Clés étrangères : id_temps, id_compte, id_devise, id_scenario, id_contrapartie
  ]
)

Cette table centralise les flux de trésorerie et permet les agrégations par période, compte, devise ou entité.

==== 2. Tables de dimensions

- *DIM_TEMPS* — Gère la granularité temporelle des opérations sur la période 2022-2024 (3 ans).

- *DIM_COMPTE* — Contient les 90 comptes financiers avec 4 types : Compte courant, Compte professionnel, Compte épargne, Compte de trésorerie.

- *DIM_DEVISE* — Répertorie les 4 devises utilisées : EUR, USD, GBP, CHF.

- *DIM_SCENARIO* — Définit les différents scénarios d'analyse (prévisionnel, réalisé, simulé…).

- *DIM_CONTREPARTIE* — Identifie les 44 contreparties : 20 clients, 15 fournisseurs, 6 banques partenaires, 3 institutions financières.

- *DIM_FILIALE* — Contient les 6 filiales européennes du groupe (France, Allemagne, UK, Suisse, Espagne, Italie).

==== 3. Relations

*FACT_FLUX_TRESORERIE* est au centre du modèle, liée à chaque dimension par des clés étrangères.

Chaque dimension entretient une relation de type 1,n avec la table de faits (une dimension peut concerner plusieurs flux).

Certaines dimensions (comme *DIM_COMPTE* et *DIM_FILIALE*) sont également liées entre elles via des clés étrangères pour représenter la hiérarchie organisationnelle.

== Modèle de données
<modèle-de-données>

Le modèle de données est conçu en flocon, optimisé pour les analyses BI.

#figure(
  image("mcd.jpg", width: 90%),
  caption: [Modèle Conceptuel de Données (MCD)]
)

#v(1em)

#figure(
  image("mld.jpg", width: 90%),
  caption: [Modèle Logique de Données (MLD)]
)

== Dictionnaire de données
<dictionnaire-de-données>

Le dictionnaire de données a pour objectif de définir de manière exhaustive l'ensemble des champs qui seront manipulés au sein du projet Crésus. Il sert de référentiel unique pour garantir une compréhension commune des informations utilisées, depuis leur source jusqu'à leur restitution.

=== Table : FACT_FLUX_TRESORERIE (Table de Faits)

Cette table est le cœur du modèle. Elle contient chaque transaction financière unitaire.

#figure(
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left, center, left),
    table.header(
      [*Champ*],
      [*Type*],
      [*Description*]
    ),
    [id_flux], [INTEGER, PK], [Identifiant unique de la transaction (flux).],
    [date_operation], [DATE], [Date effective de l'opération.],
    [montant_transaction], [NUMERIC], [Montant de la transaction dans la devise d'origine.],
    [montant_consolide_eur], [NUMERIC], [Montant converti en EUR pour la consolidation.],
    [type_operation], [VARCHAR], [Nature de l'opération : Virement émis, Virement reçu, Dépôt, Retrait, Prêt, Remboursement prêt, Frais bancaires, Intérêts débiteurs, Intérêts créditeurs.],
    [statut], [VARCHAR], [Statut de la transaction : Réalisé ou Prévisionnel.],
    [id_compte], [INTEGER, FK], [Clé étrangère liant à la table DIM_COMPTE.],
    [id_devise], [INTEGER, FK], [Clé étrangère liant à DIM_DEVISE.],
    [id_scenario], [INTEGER, FK], [Clé étrangère liant à DIM_SCENARIO.],
    [id_temps], [INTEGER, FK], [Clé étrangère liant à DIM_TEMPS.],
    [id_contrepartie], [INTEGER, FK], [Clé étrangère liant à DIM_CONTREPARTIE.]
  ),
  caption: [Structure de la table FACT_FLUX_TRESORERIE]
)

=== Tables de dimensions

==== DIM_TEMPS

Gère la granularité temporelle des opérations.

#figure(
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left, center, left),
    table.header([*Champ*], [*Type*], [*Description*]),
    [id_temps], [INTEGER, PK], [Identifiant unique de la date.],
    [jour], [INTEGER], [Jour du mois (1-31).],
    [mois], [INTEGER], [Mois de l'année (1-12).],
    [annee], [INTEGER], [Année (2022, 2023 ou 2024 pour le POC).]
  ),
  caption: [Structure de la table DIM_TEMPS]
)

==== DIM_SCENARIO

Définit les différents scénarios d'analyse (réalisé, prévision, simulation).

#figure(
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left, center, left),
    table.header([*Champ*], [*Type*], [*Description*]),
    [id_scenario], [INTEGER, PK], [Identifiant unique du scénario.],
    [nom_scenario], [VARCHAR], [Nom du scénario : Réalisé, Prévisionnel, Simulation.],
    [description], [TEXT], [Description détaillée du scénario.]
  ),
  caption: [Structure de la table DIM_SCENARIO]
)

==== DIM_DEVISE

Répertorie les devises utilisées pour les transactions et les comptes.

#figure(
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left, center, left),
    table.header([*Champ*], [*Type*], [*Description*]),
    [id_devise], [INTEGER, PK], [Identifiant unique de la devise.],
    [code_iso], [VARCHAR(3)], [Code ISO 4217 de la devise (EUR, USD, GBP, CHF).],
    [libelle_devise], [VARCHAR], [Nom complet (Euro, Dollar américain, Livre sterling, Franc suisse).]
  ),
  caption: [Structure de la table DIM_DEVISE]
)

==== DIM_COMPTE

Contient les informations des comptes financiers du groupe.

#figure(
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left, center, left),
    table.header([*Champ*], [*Type*], [*Description*]),
    [id_compte], [INTEGER, PK], [Identifiant unique du compte.],
    [numero_compte], [VARCHAR], [Identifiant métier du compte (IBAN).],
    [type_compte], [VARCHAR], [Type de compte : Compte courant, Compte professionnel, Compte épargne, Compte de trésorerie.],
    [id_devise], [INTEGER, FK], [Clé étrangère liant à DIM_DEVISE.],
    [id_filiale], [INTEGER, FK], [Clé étrangère liant à DIM_FILIALE.]
  ),
  caption: [Structure de la table DIM_COMPTE]
)

==== DIM_CONTREPARTIE

Identifie les entités externes ou internes impliquées dans les opérations.

#figure(
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left, center, left),
    table.header([*Champ*], [*Type*], [*Description*]),
    [id_contrepartie], [INTEGER, PK], [Identifiant unique de la contrepartie.],
    [nom_contrepartie], [VARCHAR], [Nom de la contrepartie (ex: "Client Entreprise 001", "BNP Paribas").],
    [type_contrepartie], [VARCHAR], [Catégorie : Client, Fournisseur, Banque partenaire, Institution financière.]
  ),
  caption: [Structure de la table DIM_CONTREPARTIE]
)

==== DIM_FILIALE

Décrit les entités et filiales du groupe ZF Banque.

#figure(
  table(
    columns: (1.5fr, 1fr, 3fr),
    align: (left, center, left),
    table.header([*Champ*], [*Type*], [*Description*]),
    [id_filiale], [INTEGER, PK], [Identifiant unique de la filiale.],
    [nom_filiale], [VARCHAR], [Nom de la filiale (ex: "ZF Banque France", "ZF Banque Allemagne", "ZF Banque UK").],
    [pays], [VARCHAR], [Pays d'implantation (France, Allemagne, Royaume-Uni, Suisse, Espagne, Italie).],
    [region], [VARCHAR], [Zone géographique (Europe pour le POC).]
  ),
  caption: [Structure de la table DIM_FILIALE]
)

== KPIs et mesures calculées
<kpis-mesures>

Les indicateurs clés de performance (KPIs) suivants sont calculés dans Power BI à partir des données de la table de faits :

#figure(
  table(
    columns: (1.5fr, 1fr, 2.5fr),
    align: (left, center, left),
    table.header([*KPI*], [*Type*], [*Description / Formule*]),
    [Trésorerie Totale], [Mesure], [Somme des montants de transactions par filiale et période.],
    [Total_Reel], [Mesure], [Somme des montants où statut = "Réalisé".],
    [Total_Budget], [Mesure], [Somme des montants où statut = "Prévisionnel".],
    [Variance_Montant], [Mesure], [Total_Reel - Total_Budget (écart en valeur absolue).],
    [Variance_Percent], [Mesure], [(Total_Reel - Total_Budget) / Total_Budget × 100.],
    [Montant moyen], [Mesure], [Moyenne des montants par type d'opération.],
    [Cumul transactions], [Mesure], [Cumul du nombre de transactions dans le temps.],
    [Répartition (%)], [Mesure], [Part de chaque type d'opération dans le total.]
  ),
  caption: [KPIs et mesures calculées dans Power BI]
)

== Mapping de données
<mapping-de-données>

Le mapping de données décrit les correspondances entre les données sources et les tables PostgreSQL, ainsi que les transformations appliquées lors du chargement.

=== Mapping de la table de faits

#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    align: (left, left, left),
    table.header(
      [*Donnée source*],
      [*Table.Colonne cible*],
      [*Transformation*]
    ),
    [id_flux], [FACT_FLUX_TRESORERIE.id_flux], [Auto-incrément],
    [date_operation], [FACT_FLUX_TRESORERIE.date_operation], [Conversion au format SQL DATE],
    [montant], [FACT_FLUX_TRESORERIE.montant], [Nettoyage caractères non numériques],
    [type_operation], [FACT_FLUX_TRESORERIE.type_operation], [Normalisation en minuscules],
    [statut], [FACT_FLUX_TRESORERIE.statut], [Valeur par défaut : "confirmé"],
    [simulation], [FACT_FLUX_TRESORERIE.simulation], [Dérivé des scénarios Power BI]
  ),
  caption: [Mapping des données vers FACT_FLUX_TRESORERIE]
)

=== Mapping des dimensions

#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    align: (left, left, left),
    table.header(
      [*Donnée source*],
      [*Table.Colonne cible*],
      [*Transformation*]
    ),
    [code_iso], [DIM_DEVISE.code_iso], [Jointure avec DIM_DEVISE],
    [libelle_devise], [DIM_DEVISE.libelle_devise], [Uniformisation majuscule],
    [taux_change], [DIM_SCENARIO (calcul)], [Intégré dans la table scénario],
    [nom_scenario], [DIM_SCENARIO.nom_scenario], [Généré automatiquement par Python],
    [description], [DIM_SCENARIO.description], [Renseigné par l'utilisateur Power BI]
  ),
  caption: [Mapping des données vers les dimensions (1/3)]
)

#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    align: (left, left, left),
    table.header(
      [*Donnée source*],
      [*Table.Colonne cible*],
      [*Transformation*]
    ),
    [nom_filiale], [DIM_FILIALE.nom_filiale], [Normalisation et suppression doublons],
    [pays], [DIM_FILIALE.pays], [Nettoyage des libellés],
    [region], [DIM_FILIALE.region], [Correspondance pays → région],
    [numero_compte], [DIM_COMPTE.numero_compte], [Masquage partiel (RGPD)],
    [type_compte], [DIM_COMPTE.type_compte], [Catégorisation automatique],
    [devise_compte], [DIM_COMPTE.devise], [Jointure avec DIM_DEVISE],
    [id_filiale], [DIM_COMPTE.id_filiale], [Clé étrangère DIM_FILIALE]
  ),
  caption: [Mapping des données vers les dimensions (2/3)]
)

#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    align: (left, left, left),
    table.header(
      [*Donnée source*],
      [*Table.Colonne cible*],
      [*Transformation*]
    ),
    [nom_contrepartie], [DIM_CONTREPARTIE.nom_contrepartie], [Uniformisation (majuscules)],
    [type_contrepartie], [DIM_CONTREPARTIE.type_contrepartie], [Normalisation via dictionnaire Python],
    [jour, mois, annee], [DIM_TEMPS], [Extraction depuis date_operation],
    [source_fichier], [Métadonnée interne], [Ajout automatique (Airflow)],
    [date_integration], [Métadonnée interne], [Générée par le pipeline Airflow]
  ),
  caption: [Mapping des données vers les dimensions (3/3)]
)

= Annexe
<annexe>
