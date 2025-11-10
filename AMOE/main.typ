#set page(paper: "a4")
#set heading(numbering: "1.")

#show link: set text(fill: blue, weight: 700)
#show link: underline

#strong[#underline[POC - BI Prédictive Finance];]

#emph[« Comment l\'analyse prédictive et la simulation peuvent-ils être
des facteurs de gains dans la gestion de trésorerie d\'une banque ? »]

= Sommaire
<sommaire>
#link(<introduction>)[1. INTRODUCTION #link(<introduction>)[2];]

#link(<but-du-document>)[#emph[#strong[1.1];] #emph[#strong[But du document];] #link(<but-du-document>)[2];]

#link(<specifications-techniques>)[2. SPECIFICATIONS TECHNIQUES #link(<specifications-techniques>)[3];]

#link(<solutions-choisies>)[#emph[#strong[2.1 Solutions choisies];] #link(<solutions-choisies>)[3];]

#link(<architecture-technique>)[#emph[#strong[2.2 Architecture technique];] #link(<architecture-technique>)[3];]

#link(<fichiers-sources>)[#emph[#strong[2.3 Fichiers sources];] #link(<fichiers-sources>)[3];]

#link(<base-de-données>)[#emph[#strong[2.4 Base de données];] #link(<base-de-données>)[4];]

#link(<modèle-de-données>)[#emph[#strong[2.5 Modèle de données];] #link(<modèle-de-données>)[5];]

#link(<dictionnaire-de-données>)[#emph[#strong[2.6 Dictionnaire de données];] #link(<dictionnaire-de-données>)[7];]

#link(<mapping-de-données>)[#emph[#strong[2.7 Mapping de données];] #link(<mapping-de-données>)[9];]

#link(<annexe>)[3. ANNEXE #link(<annexe>)[10];]

= INTRODUCTION
<introduction>
== #emph[#strong[But du document];]
<but-du-document>
#quote(block: true)[
Cette fiche a pour but de présenter les spécifications techniques du
Proof of Concept (POC) pour le projet \"Crésus\". Elle détaille
l\'architecture, les technologies et la structure des données qui seront
mises en œuvre pour démontrer la faisabilité et la valeur d\'une
solution de BI prédictive pour la gestion de trésorerie du groupe ZF
Banque.

Plus concrètement, le document rassemble les livrables clés du POC, à
savoir :
]

- Les fichiers sources utilisés

- L'architecture technique détaillée de la solution

- Le dictionnaire de données (KPI..)

- Les Modèles Conceptuel et Logique de Données (MCD / MDL)

- Le mapping de données.

=  SPECIFICATIONS TECHNIQUES
<specifications-techniques>
== #emph[#strong[2.1 Solutions choisies];]
<solutions-choisies>
- #strong[Base de données :] PostgreSQL

- #strong[Orchestrateur de flux :] Apache Airflow

- #strong[Modélisation et génération de données :] Scripts Python

- #strong[Data Visualisation et Simulation :] Microsoft Power BI Desktop

== #emph[#strong[2.2 Architecture technique];]
<architecture-technique>
L\'architecture proposée suit un flux en quatre étapes :

+ #strong[Sources de données :] Génération de données synthétiques (flux
  de trésorerie) via un script Python et intégration de données de
  marché externes (ex: taux de change via fichiers CSV).

+ #strong[Ingestion & stockage :] Centralisation des données brutes et
  structurées dans une base de données PostgreSQL.

+ #strong[Modélisation & simulation :] Orchestration par Apache Airflow
  de pipelines (DAGs) pour extraire, transformer les données, entraîner
  les modèles prédictifs et stocker les résultats (prévisions,
  simulations) dans PostgreSQL.

+ #strong[Restitution & utilisation :] Connexion de Power BI à
  PostgreSQL pour visualiser les données historiques, les prévisions et
  permettre aux utilisateurs de lancer des simulations interactives
  (scénarios \"what-if\").

== #emph[#strong[2.3 Fichiers sources];]
<fichiers-sources>
Les fichiers sources constituent le point d'entrée principal du projet.
Ils rassemblent l'ensemble des données nécessaires à la mise en œuvre de
la solution de BI prédictive appliquée à la gestion de la trésorerie.

Ces données proviennent à la fois de sources internes, correspondant aux
opérations financières du groupe, et de sources externes, issues des
marchés monétaires et financiers.

Deux types de données sont exploités :

- #strong[Les flux de trésorerie] (interne), représentant les opérations
  financières réalisées par les filiales du groupe.

- #strong[Les cours de change des devises] (externe), permettant de
  prendre en compte les variations de taux dans les analyses et les
  simulations de trésorerie.

L'ensemble des fichiers sources a été généré ou importé sous format CSV.
Les jeux de données internes ont été produits à l'aide d'un script
Python simulant des transactions financières réalistes, tandis que les
données externes proviennent de fichiers de marché contenant
l'historique des taux de change.

Ces fichiers constituent la première étape du flux de traitement des
données. Ils sont ensuite intégrés dans la base de données PostgreSQL,
structurés selon le modèle de données défini, documentés dans le
dictionnaire de données, puis mappés vers les différentes tables cibles
utilisées pour les analyses et visualisations. Cette chaîne assure la
cohérence, la traçabilité et la fiabilité des informations exploitées
dans l'outil Power BI.

== #emph[#strong[2.4 Base de données];]
<base-de-données>
La base de données, gérée sous PostgreSQL, a été choisie pour sa
robustesse, sa flexibilité et ses capacités avancées en SQL. Elle
centralisera l'ensemble des données du projet, qu'elles soient internes
(générées) ou externes, et contiendra aussi bien les données brutes que
les données préparées pour l'analyse, ainsi que les résultats des
prévisions et des simulations. Sa structure est pensée pour garantir la
cohérence, la traçabilité et la performance des requêtes effectuées,
notamment depuis Power BI.

Ce choix s'explique par le fait que PostgreSQL est reconnu comme un
standard de l'industrie, compatible avec de nombreux outils, ce qui en
facilite l'intégration. C'est une base performante, capable de gérer la
montée en charge et de traiter de grosses volumétries. En tant que base
relationnelle, PostgreSQL permet de diviser les données en plusieurs
tables et de les lier via des requêtes plus ou moins complexes. Enfin,
sa compatibilité avec l'écosystème Python et sa gestion avancée des
types JSON offrent la possibilité de stocker et manipuler des données
semi-structurées si besoin.

2.4.1 Structure de la base

#underline[\1. Table de faits]

#quote(block: true)[
#strong[FACT\_FLUX\_TRESORERIE] Contient l'ensemble des transactions
financières.

Champs principaux :
]

- id\_flux (clé primaire)

- montant

- date\_operation

- type\_operation

- statut

- Clés étrangères : id\_temps, id\_compte, id\_devise, id\_scenario,
  id\_contrapartie

Cette table centralise les flux de trésorerie et permet les agrégations
par période, compte, devise ou entité.

#underline[\2. Tables de dimensions]

- #strong[DIM\_TEMPS] \
  Gère la granularité temporelle des opérations (jour, mois, année). \
  Permet les analyses par période (mois, trimestre, année).

- #strong[DIM\_COMPTE] \
  Contient les informations des comptes financiers (numéro, type de
  compte, filiale associée).

- #strong[DIM\_DEVISE] \
  Répertorie les devises utilisées, avec leur code ISO et libellé.

- #strong[DIM\_SCENARIO] \
  Définit les différents scénarios d'analyse (prévisionnel, réalisé,
  simulé…).

- #strong[DIM\_CONTREPARTIE] \
  Identifie les entités externes impliquées dans les opérations
  (fournisseurs, clients, partenaires).

- #strong[DIM\_FILIALE] \
  Contient les informations des filiales du groupe (nom, pays, région).

#underline[\3. Relations]

#strong[FACT\_FLUX\_TRESORERIE] est au centre du modèle, liée à chaque
dimension par des clés étrangères.

Chaque dimension entretient une relation de type 1,n avec la table de
faits (une dimension peut concerner plusieurs flux).

Certaines dimensions (comme #strong[DIM\_COMPTE] et
#strong[DIM\_FILIALE];) sont également liées entre elles via des clés
étrangères pour représenter la hiérarchie organisationnelle.

== #emph[#strong[2.5 Modèle de données];]
<modèle-de-données>
Le modèle de données est conçu en flocon, optimisé pour les analyses BI.

#emph[#underline[Voici le modèle conceptuel de données (MCD) :];]

#image("mcd.jpg")

#emph[#underline[Ainsi que le modèle logique des données (MLD) :];]

#image("mld.jpg")

== #emph[#strong[2.6 Dictionnaire de données];]
<dictionnaire-de-données>
Le dictionnaire de données a pour objectif de définir de manière
exhaustive l\'ensemble des champs qui seront manipulés au sein du projet
Crésus. Il sert de référentiel unique pour garantir une compréhension
commune des informations utilisées, depuis leur source jusqu\'à leur
restitution.

=== #strong[Table : FACT\_FLUX\_TRESORERIE (Table de Faits)]
<table-fact_flux_tresorerie-table-de-faits>
Cette table est le cœur du modèle. Elle contient chaque transaction
financière unitaire.

- #strong[id\_flux] (INTEGER, PK) : Identifiant unique de la transaction
  (flux).

- #strong[date\_operation] (DATE) : Date effective de l\'opération.

- #strong[montant\_transaction] (NUMERIC) : Montant de la transaction
  dans la devise d\'origine.

- #strong[montant\_consolide\_eur] (NUMERIC) : Montant de la transaction
  converti en EUR pour la consolidation.

- #strong[type\_operation] (VARCHAR) : Nature de l\'opération (ex:
  \"Virement émis\", \"Virement reçu\", \"Prêt\").

- #strong[statut] (VARCHAR) : Statut de la transaction (ex: \"Réalisé\",
  \"Prévisionnel\", \"En attente\").

- #strong[id\_compte] (INTEGER, FK) : Clé étrangère liant à la table
  DIM\_COMPTE.

- #strong[id\_devise] (INTEGER, FK) : Clé étrangère liant à la table
  DIM\_DEVISE (devise de la transaction).

- #strong[id\_scenario] (INTEGER, FK) : Clé étrangère liant à la table
  DIM\_SCENARIO.

- #strong[id\_temps] (INTEGER, FK) : Clé étrangère liant à la table
  DIM\_TEMPS.

- #strong[id\_contrepartie] (INTEGER, FK) : Clé étrangère liant à la
  table DIM\_CONTREPARTIE.

=== #strong[Tables de dimensions]
<tables-de-dimensions>
#strong[Table : DIM\_TEMPS]

- Gère la granularité temporelle des opérations.

- #strong[id\_temps] (INTEGER, PK) : Identifiant unique de la date.

- #strong[jour] (INTEGER) : Jour du mois (1-31).

- #strong[mois] (INTEGER) : Mois de l\'année (1-12).

- #strong[annee] (INTEGER) : Année (ex: 2024).

#strong[Table : DIM\_SCENARIO]

- Définit les différents scénarios d\'analyse (réalisé, prévision,
  simulation).

- #strong[id\_scenario] (INTEGER, PK) : Identifiant unique du scénario.

- #strong[nom\_scenario] (VARCHAR) : Nom du scénario (ex: \"Réalisé
  2024\", \"Prévisionnel S1 2025\", \"Simulation Taux +1%\").

- #strong[description] (TEXT) : Description détaillée du scénario.

#strong[Table : DIM\_DEVISE]

- Répertorie les devises utilisées pour les transactions et les comptes.

- #strong[id\_devise] (INTEGER, PK) : Identifiant unique de la devise.

- #strong[code\_iso] (VARCHAR(3)) : Code ISO 4217 de la devise (ex:
  \"EUR\", \"USD\", \"GBP\").

- #strong[libelle\_devise] (VARCHAR) : Nom complet de la devise (ex:
  \"Euro\", \"Dollar Américain\").

#strong[Table : DIM\_COMPTE]

- Contient les informations des comptes financiers du groupe.

- #strong[id\_compte] (INTEGER, PK) : Identifiant unique du compte.

- #strong[numero\_compte] (VARCHAR) : Identifiant métier du compte (ex:
  IBAN ou numéro interne).

- #strong[type\_compte] (VARCHAR) : Type de compte (ex: \"Compte
  courant\", \"Compte à terme\", \"Compte de prêt\").

- #strong[id\_devise] (INTEGER, FK) : Clé étrangère liant à la devise
  principale du compte (DIM\_DEVISE).

- #strong[id\_filiale] (INTEGER, FK) : Clé étrangère liant à la filiale
  propriétaire du compte (DIM\_FILIALE).

#strong[Table : DIM\_CONTREPARTIE]

- Identifie les entités externes ou internes impliquées dans les
  opérations.

- #strong[id\_contrepartie] (INTEGER, PK) : Identifiant unique de la
  contrepartie.

- #strong[nom\_contrepartie] (VARCHAR) : Nom de la contrepartie (ex:
  \"Client A\", \"Fournisseur B\", \"Trésorerie Centrale\").

- #strong[type\_contrepartie] (VARCHAR) : Catégorie de la contrepartie
  (ex: \"Client\", \"Fournisseur\", \"Banque\", \"Interco\").

#strong[Table : DIM\_FILIALE]

- Décrit les entités et filiales du groupe ZF Banque.

- #strong[id\_filiale] (INTEGER, PK) : Identifiant unique de la filiale.

- #strong[nom\_filiale] (VARCHAR) : Nom légal ou usuel de la filiale
  (ex: \"ZF Banque France\", \"ZF Bank North America\").

- #strong[pays] (VARCHAR) : Pays d\'implantation de la filiale.

- #strong[region] (VARCHAR) : Zone géographique de rattachement (ex:
  \"Europe\", \"Amérique du Nord\", \"Asie\").

== 
<section>
== 
<section-1>
== 
<section-2>
== 
<section-3>
== 
<section-4>
== 
<section-5>
== #emph[#strong[2.7 Mapping de données];]
<mapping-de-données>
#figure(
  align(center)[#table(
    columns: (17.06%, 22.47%, 16.19%, 18.32%, 25.97%),
    align: (auto,auto,auto,auto,auto,),
    table.header(table.cell(align: left)[#strong[Données];], [#strong[Table
      \/ Colonne
      (PostgreSQL)];], [#strong[Format];], [#strong[Description];], [#strong[Transformation
      appliquée];],),
    table.hline(),
    [id\_flux], [FACT\_FLUX\_TRESORERIE.id\_flux], [Integer], [Identifiant
    unique du flux de trésorerie], [Généré automatiquement
    (auto-incrément)],
    [date\_operation], [FACT\_FLUX\_TRESORERIE.date\_operation], [Date
    (YYYY-MM-DD)], [Date effective de l'opération
    financière], [Conversion au format SQL DATE],
    [montant], [FACT\_FLUX\_TRESORERIE.montant], [Decimal(15,2)], [Montant
    de la transaction], [Nettoyage (suppression caractères non
    numériques)],
    [type\_operation], [FACT\_FLUX\_TRESORERIE.type\_operation], [Texte], [Nature
    du flux : entrée, sortie, placement, remboursement], [Normalisation
    en minuscules, mapping via dictionnaire (entrée/sortie)],
    [statut], [FACT\_FLUX\_TRESORERIE.statut], [Texte], [Statut du flux
    : confirmé / en attente / annulé], [Valeur par défaut : \"confirmé\"
    si non précisé],
    [simulation], [FACT\_FLUX\_TRESORERIE.simulation], [Booléen], [Indique
    si le flux est réel ou simulé], [Champ dérivé des scénarios de
    simulation Power BI],
    [code\_iso (CSV marché)], [Devises.id\_devise], [Texte], [Code de la
    devise ISO (EUR, USD, XAF, etc.)], [Jointure avec la table
    DIM\_DEVISE],
    [libelle\_devise (CSV
    marché)], [Devises.libelle\_devise], [Texte], [Nom de la
    devise], [Uniformisation majuscule / suppression accents],
    [taux\_change (fichier marché)], [DIM\_SCENARIO (via calcul
    simulation)], [Decimal(6,4)], [Valeur du taux de change
    EUR/Devise], [Intégré dans la table scénario pour la simulation],
    [nom\_scenario (script
    simulation)], [DIM\_SCENARIO.nom\_scenario], [Texte], [Libellé du
    scénario (\"Hausse taux\", \"Baisse USD\", etc.)], [Généré
    automatiquement par le script Python],
    [description
    (scénario)], [DIM\_SCENARIO.description], [Texte], [Détail du
    scénario de simulation appliqué], [Renseigné par l'utilisateur dans
    Power BI],
    [nom\_filiale (fichier
    interne)], [DIM\_FILIALE.nom\_filiale], [Texte], [Nom de la
    filiale], [Normalisation et suppression doublons],
    [pays (fichier interne)], [DIM\_FILIALE.pays], [Texte], [Pays de la
    filiale], [Nettoyage des libellés, harmonisation],
    [region], [DIM\_FILIALE.region], [Texte], [Zone géographique de
    rattachement], [Ajout automatique via correspondance pays → région],
    [numero\_compte], [DIM\_COMPTE.numero\_compte], [Texte (IBAN
    partiel)], [Numéro du compte de la filiale], [Masquage partiel
    (RGPD)],
    [type\_compte], [DIM\_COMPTE.type\_compte], [Texte], [Compte
    courant, placement, réserve], [Catégorisation automatique selon
    libellé],
    [devise\_compte], [DIM\_COMPTE.devise], [Texte], [Code ISO de la
    devise du compte], [Jointure avec table DIM\_DEVISE],
    [id\_filiale], [DIM\_COMPTE.id\_filiale], [Integer], [Lien entre
    compte et filiale], [Clé étrangère issue de DIM\_FILIALE],
    [nom\_contrepartie], [DIM\_CONTREPARTIE.nom\_contrepartie], [Texte], [Nom
    de la banque ou institution partenaire], [Uniformisation
    (majuscules, suppression ponctuation)],
    [type\_contrepartie], [DIM\_CONTREPARTIE.type\_contrepartie], [Texte], [Banque,
    client, fournisseur, marché], [Normalisation via dictionnaire
    Python],
    [id\_compte\_source], [FACT\_FLUX\_TRESORERIE (via relation
    #emph[Émettre];)], [Integer], [Compte émetteur du flux], [Clé
    étrangère liée à DIM\_COMPTE],
    [id\_compte\_cible], [FACT\_FLUX\_TRESORERIE (via relation
    #emph[Recevoir];)], [Integer], [Compte récepteur du flux], [Clé
    étrangère liée à DIM\_COMPTE],
    [jour, mois, annee], [DIM\_TEMPS], [Integer], [Découpage temporel du
    flux], [Extraction automatique depuis date\_operation],
    [source\_fichier], [Métadonnée interne], [Texte], [Nom du fichier
    source CSV importé], [Ajout automatique lors du chargement Airflow],
    [date\_integration], [Métadonnée interne], [Timestamp], [Date de
    l'import dans PostgreSQL], [Générée par le pipeline Airflow],
  )]
  , kind: table
  )

=== #strong[ \
]
<section-6>
= 3. ANNEXE
<annexe>
