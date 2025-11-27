// ═══════════════════════════════════════════════════════════════════════════
// CONFIGURATION DU DOCUMENT
// ═══════════════════════════════════════════════════════════════════════════

#set document(
  title: "Fiche d'expertise – BI Prédictive Finance",
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
        align(right)[Fiche d'expertise AMOA]
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
          Fiche d'expertise
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
        Direction Financière
      ],
      [
        #set text(size: 10pt, fill: rgb("#64748b"))
        *Document* \
        Fiche d'expertise AMOA \
        Phase de cadrage
      ]
    )
  ]
  
  #v(2cm)
]

// ═══════════════════════════════════════════════════════════════════════════
// TABLE DES MATIÈRES
// ═══════════════════════════════════════════════════════════════════════════

#page[
  #heading(level: 1, numbering: none)[Table des matières]
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

Cette fiche d'expertise a pour but de *structurer la réflexion stratégique* autour du projet "Crésus". Elle analyse l'opportunité pour le groupe ZF Banque d'implémenter une solution de Business Intelligence prédictive afin d'optimiser sa gestion de trésorerie. Ce document sert de fondation à la phase de cadrage du projet, en définissant globalement le périmètre, les enjeux, les solutions technologiques potentielles dans un cadre assez large et une démarche de mise en œuvre. Il vise à fournir à la MOE les éléments nécessaires pour prendre une décision éclairée sur le lancement du projet.

== Définition
<définition>

Le projet Crésus consiste à mettre en place une plateforme centralisée de pilotage prédictif de la trésorerie. Cette solution s'appuiera sur les technologies de Big Data et de Machine Learning pour agréger, analyser et modéliser l'ensemble des flux financiers du groupe ZF Banque. L'objectif est de passer d'une gestion réactive à une gestion proactive et optimisée, rechercher la meilleure solution possible, capable d'anticiper les besoins et les éventuels excédents de liquidités, mais aussi dans une certaine mesure de simuler l'impact des variations de marché (SWOT) et d'aider à la prise de décision stratégique en matière de placement, financement et couverture de risques, en somme, toute la stratégie fonctionnelle.

= Concepts généraux
<concepts-generaux>

== Compréhension du contexte
<compréhension-du-contexte>

Le groupe *ZF Banque* est un acteur international de la banque de détail comprenant une dizaine de filiales présentes en Europe, en Afrique ainsi qu'en Amérique du Nord. Suivant la nomination de son nouveau Directeur Général, M. Paul en 2017, le groupe a initié une phase de transformation stratégique qui aura un impact sur ses 2800 agences et 5000 collaborateurs.

La direction générale a établi un plan quinquennal et identifié plusieurs chantiers prioritaires, visant notamment à moderniser les outils de gestion de trésorerie. Ce projet porté par la direction financière s'inscrit dans une stratégie à plus globale ayant pour objectif l'amélioration de la rentabilité du groupe ainsi que l'exploitation des nouvelles technologies comme leviers de performances.

C'est dans ce contexte et avec une ambition de croissance qu'a été lancé le projet Crésus, visant à doter le groupe de meilleurs outils prédictifs et accroitre les possibilités d'optimisation financière.

== Compréhension de la problématique
<compréhension-de-la-problématique>

La problématique posée dans le cadre du projet Crésus est la suivante :

#quote[Comment l'analyse prédictive et la simulation peuvent-elles être des facteurs de gains dans la gestion de trésorerie d'une banque ?]

Afin d'y répondre, il convient d'examiner dans quelle mesure ces méthodes et technologies peuvent améliorer la capacité du groupe à anticiper ses flux financiers, à modéliser divers scénarios et à en tirer des bénéfices concrets en termes de pilotage et d'optimisation de la trésorerie.

Cette problématique s'articule autour de plusieurs défis auxquels fait face le groupe ZF Banque :

- *Manque de visibilité :* Les positions de trésoreries peuvent être complexes et hétérogènes en raison des nombreuses sources de données.

- *Incapacité à anticiper :* Dû à sa présence internationale, de nombreuses devises sont utilisées dans le cadre des opérations du groupe, rendant les prévisions de trésorerie moins fiables.

- *Gestion des risques :* En raison du manque de visibilité et de l'incapacité à anticiper les diverses devises, il n'est pas possible de réaliser des scénarios de stress du marché utilisant des données réelles et des prévisions réalistes, privant le groupe d'opportunités financières.

== Enjeux et objectifs
<enjeux-et-objectifs>

En nous basant sur les sections 1.2 et 1.3 du cahier des charges, nous pouvons isoler 3 enjeux principaux :

+ *Financier :* Optimiser le rendement des liquidités et réduire les coûts financiers pour améliorer directement la rentabilité du groupe. Cela passe d'abord par une meilleure centralisation des flux financiers grâce à des dispositifs comme le *cash pooling* ou le *netting*, permettant de rationaliser la gestion de trésorerie au niveau du groupe. En complément, la mise en place d'*algorithmes d'optimisation* contribuerait à maximiser le rendement disponible. Le suivi en temps réel de la trésorerie consolidée, par entité ou par juridiction, est également essentiel pour identifier rapidement les excédents et besoins.

  Cependant, l'optimisation des coûts ne fait pas tout. En effet, il est également important de les réduire. Cela peut être réalisé via l'*automatisation de la gestion des financements intra-groupe*, qui aura pour conséquence de limiter le recours aux emprunts externes, souvent plus coûteux.

  Par ailleurs, la *négociation et le suivi centralisé des conditions bancaires* (taux d'intérêt, commissions, frais de transaction) apportent une visibilité et un pouvoir de négociation accrus.

  Enfin, le recours à l'*analyse prédictive des besoins de financement*, via des modèles statistiques ou de l'intelligence artificielle, permet d'anticiper les tensions de trésorerie et d'éviter le recours à des financements d'urgence aux conditions défavorables.

+ *Stratégique :* Doter la Direction Financière d'un outil puissant pour en faire un véritable partenaire stratégique de la Direction Générale.

  Au-delà de son rôle traditionnel, la fonction Finance doit évoluer pour devenir un véritable *partenaire stratégique* de la Direction Générale. Cela implique de fournir une vision consolidée et prospective de la situation financière du groupe. La production de scénarios alternatifs offre une capacité d'anticipation renforcée. De même, l'intégration de *KPIs financiers clés* permet d'aligner les décisions financières avec la stratégie globale. Dans cette optique, l'*aide à la décision en temps réel* devient un levier majeur. Des simulations automatiques d'impacts financiers peuvent aider à la prise de décision, qu'il s'agisse d'investissements, d'acquisitions ou de désinvestissements. En parallèle, des rapports à divers niveaux, adaptés à la Direction Générale comme aux filiales, offrent un pilotage plus fin et une meilleure réactivité.

+ *Opérationnel :* Fiabiliser et automatiser les processus pour permettre aux équipes de se concentrer sur des tâches à plus haute valeur ajoutée.

  Les tâches répétitives doivent donc être automatisées, notamment l'intégration avec l'ERP et les systèmes comptables, la génération automatique des rapprochements bancaires et la détection des anomalies telles que les paiements en doublon ou les écarts non expliqués. La sécurisation des données et la conformité réglementaire sont également essentielles.

  Ces améliorations permettent aux équipes de se concentrer sur l'analyse, le pilotage et le conseil, en libérant du temps pour des missions à plus forte valeur ajoutée et en augmentant la fiabilité des décisions financières.

=== Objectifs et démarches

L'objectif de cette démarche est d'*améliorer la gestion de la trésorerie et la résilience financière du groupe* en combinant anticipation, analyse et optimisation. Il s'agit de fournir aux équipes financières des outils capables de transformer les données en recommandations opérationnelles et stratégiques.

Les principales démarches incluent :

- *Anticiper les flux de trésorerie* : prévoir les entrées et sorties de cash dans toutes les devises et pour toutes les filiales, afin d'identifier les excédents ou besoins à court et moyen terme. Cette anticipation repose sur l'intégration de données des différents systèmes bancaires du groupe, avec des modèles de prévision basés sur l'historique et les tendances saisonnières.

- *Élaborer une stratégie de couverture* : définir les instruments de couverture les plus adaptés (taux d'intérêt, devises) en fonction de scénarios prévisionnels. L'analyse repose sur des simulations "what-if" pour évaluer l'impact de variations de taux ou de change, et optimiser la protection contre les risques financiers.

- *Optimiser les arbitrages financiers* : recommander des décisions de refinancement, de placement ou de remboursement anticipé en s'appuyant sur des analyses de rentabilité et de coût, basées sur les données consolidées et les prévisions de trésorerie.

- *Simuler des scénarios de crise (stress tests)* : évaluer la résilience financière du groupe face à des chocs externes ou internes, tels que des variations importantes de taux ou de change, des retards de paiement clients, ou des crises de liquidité. Ces simulations permettent de définir des plans d'action préventifs et de renforcer la robustesse du groupe.

L'ensemble de ces démarches repose sur *l'exploitation de données fiables et consolidées*, l'automatisation des calculs et la génération de rapports dynamiques pour soutenir la décision stratégique et opérationnelle.

== Finalités
<finalités>

La finalité du projet "Crésus" est de transformer la fonction trésorerie en un véritable centre de performance et d'intelligence stratégique. L'objectif est de fournir à la banque les outils et les données nécessaires pour piloter sa liquidité et ses risques financiers de manière proactive, tout en générant de la valeur tangible pour le groupe.

Concrètement, le projet doit permettre de :

- *Piloter proactivement la liquidité et les risques financiers* : disposer d'une vision consolidée et en temps réel de la trésorerie, avec des alertes automatiques et des scénarios prévisionnels pour anticiper les tensions de liquidité et ajuster rapidement les positions financières.

- *Générer des gains directs* : grâce à une allocation intelligente des ressources financières, optimiser les placements à court terme, les refinancements et les arbitrages, afin de maximiser le rendement et réduire les coûts financiers.

- *Créer un actif de données centralisé et gouverné* : consolider et fiabiliser l'ensemble des informations financières pour en faire un référentiel exploitable non seulement par la trésorerie, mais également par d'autres départements tels que la Direction des Risques, l'ALM ou le contrôle de gestion. Cela inclut des normes de qualité des données, des pipelines automatisés, et des outils d'accès et d'analyse sécurisés.

L'ensemble vise à *renforcer la performance globale du groupe*, en transformant les données financières en un levier stratégique, à la fois opérationnel et décisionnel.

== Aspects juridiques
<aspects-juridiques>

La mise en place de la solution doit respecter un cadre réglementaire très strict. Le projet devra respecter les contraintes suivantes :

- *Réglementations bancaires :* conformité avec les accords de Bâle III/IV et avec les exigences locales

- *Protection des données :* respect du RGPD en Europe et des réglementations locales (Patriot Act aux États-Unis, LPRPDE au Canada…)

- *Souveraineté des données :* L'architecture devra permettre de respecter les lois de certains pays qui exigent que les données financières restent sur leur territoire

- *Secret bancaire et cybersécurité :* La plateforme centralisera des données hautement critiques. La sécurité des accès et le cryptage des données seront des priorités absolues

- *Audit et traçabilité :* obligation de conserver la trace des décisions financières et des données utilisées pour les prévisions

== Axe méthodologique
<axe-méthodologique>

=== Organisation

#block(
  width: 100%,
  inset: 1em,
  fill: rgb("#f8fafc"),
  radius: 4pt,
  stroke: 1pt + rgb("#e2e8f0"),
  [
    - *MOA :* Directeur Général, Direction Financière
    - *MOE :* Direction des Systèmes d'Information
    - *Utilisateurs finaux :* trésoriers, analystes financiers, contrôleurs de gestion
  ]
)

=== Comitologie

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #block(
      width: 100%,
      inset: 1em,
      fill: rgb("#eff6ff"),
      radius: 4pt,
      stroke: 1pt + rgb("#bfdbfe"),
      [
        *Comité de pilotage* \
        Direction Générale, Direction des Affaires Financières, DSI, responsables des filiales \
        _Fréquence : mensuelle ou trimestrielle_
      ]
    )
  ],
  [
    #block(
      width: 100%,
      inset: 1em,
      fill: rgb("#f0fdf4"),
      radius: 4pt,
      stroke: 1pt + rgb("#bbf7d0"),
      [
        *Comité projet* \
        Chef de projet MOA et MOE, experts techniques, représentants métiers \
        _Fréquence : hebdomadaire_
      ]
    )
  ]
)

=== Méthodologie

Une approche hybride sera utilisée pour le projet :

- *Cycle en V* pour les phases de cadrage, de spécifications fonctionnelles, de validation réglementaire et de sécurité. Cette démarche garantit la conformité avec les exigences légales et assure un suivi documentaire strict.

- *Méthodologies agiles* pour les phases de développement des modèles prédictifs, de construction des tableaux de bord et de restitution des indicateurs. Cette approche permet des livraisons incrémentales, une forte implication des utilisateurs et une adaptation rapide aux ajustements métiers.

==== Phase cycle en V

+ *Kick-off :* lancement et définition des objectifs stratégiques, du périmètre, des contraintes légales et réglementaires.

+ *Analyse et spécifications fonctionnelles :* formalisation des besoins métiers, validation par la MOA et le comité projet.

+ *Conception :* choix des solutions techniques et de l'architecture cible.

+ *Validation réglementaire et sécurité :* tests de conformité, audit des données, documentation officielle.

+ *Validation finale :* validation des exigences globales par la MOA, la MOE et les utilisateurs.

==== Phase agile

+ *Sprints de développement :* construction incrémentale des modèles prédictifs et tableaux de bord.

+ *Revue utilisateur :* présentation des livraisons, collecte des retours et ajustements.

+ *Tests et ajustements :* amélioration continue des fonctionnalités et conformité métier.

+ *Déploiement progressif :* mise en production par étapes, suivi des indicateurs et adaptation selon les besoins.

+ *Gouvernance continue :* suivi post-déploiement, optimisation des modèles et maintenance évolutive

= Le marché des Big Data et de l'IA en Finance
<le-marche-des-big-data-et-de-lia-en-finance>

Le marché est en pleine effervescence. Les institutions financières investissent massivement pour passer de l'analytique descriptive ("que s'est-il passé ?") à l'analytique prédictive ("que va-t-il se passer ?") et prescriptive ("que devrions-nous faire ?"). Les tendances clés sont l'adoption du *Cloud* pour sa flexibilité, les architectures *Lakehouse* qui unifient data lakes et data warehouses, et l'utilisation d'algorithmes de *Machine Learning* pour des prévisions de plus en plus fines (ex: modèles de séries temporelles comme Prophet ou ARIMA).

== Les éditeurs et leurs outils
<les-éditeurs-et-leurs-outils>

Pour répondre aux attentes de ZF Banque, notre proposition s'articule autour d'un écosystème technologique cohérent et accessible, capable de démontrer la valeur de l'analyse prédictive sans nécessiter des mois de développement. L'objectif est de construire un *Proof of Concept (POC)* probant. Nous avons donc sélectionné des outils qui sont non seulement des standards de l'industrie, mais aussi accessibles via des offres gratuites ou les crédits étudiants Azure.

#block(
  width: 100%,
  inset: 1em,
  fill: rgb("#fef3c7"),
  radius: 4pt,
  stroke: 1pt + rgb("#fcd34d"),
  [
    *Rappel sur la génération des données :* La pierre angulaire de notre projet sera la création d'un jeu de données synthétique mais réaliste. Un script *Python* sera chargé de générer des historiques de flux de trésorerie multi-filiales et multi-devises. Ce script intègrera également des données de marché externes simulées (ou récupérées de sources publiques gratuites), comme les taux de change, afin de répondre à l'enjeu d'intégration de sources hétérogènes.
  ]
)

#v(1em)

Notre sélection d'outils est structurée pour répondre aux grands objectifs du projet :

#figure(
  table(
    columns: (1fr, 0.6fr, 2fr),
    align: (left, center, left),
    table.header(
      [*Objectif du projet "Crésus"*],
      [*Outil proposé*],
      [*Rôle et justification*]
    ),
    [*1. Centraliser et préparer les données* (internes et externes)],
    [*PostgreSQL*],
    [PostgreSQL nous permettra de centraliser l'ensemble des données internes (transactions, positions de trésorerie) et externes (taux de change, indicateurs, ...). Grâce à ses capacités avancées en SQL et à ses extensions (comme timescaledb pour les séries temporelles), il constituera une fondation solide pour la préparation et la mise à disposition des données destinées aux analyses.],
    
    [*2. Analyser, prédire et simuler* (Le cœur de l'intelligence)],
    [*Apache Airflow*],
    [Airflow permettra d'automatiser et de planifier nos pipelines de données et de modélisation. Chaque étape — extraction, transformation, entraînement de modèles prédictifs (via des scripts Python), simulation de scénarios — sera définie comme une tâche dans un DAG. Airflow assurera ainsi la reproductibilité, la traçabilité et la fiabilité de notre chaîne de traitement de données.],
    
    [*3. Restituer et permettre l'interaction* (La prise de décision)],
    [*Microsoft Power BI Desktop*],
    [*La vitrine interactive de notre travail.* Power BI est gratuit et se connecte nativement aux services Azure. Nous l'utiliserons pour :
    - *Visualiser* les positions de trésorerie historiques et prévisionnelles.
    - *Permettre la simulation* via des filtres et paramètres interactifs. L'utilisateur pourra lui-même faire varier une hypothèse (ex: un taux de change) et voir l'impact sur la trésorerie future.]
  ),
  caption: [Sélection des outils technologiques]
)

== Technologies et architectures
<technologies-et-architectures>

Nous proposons une architecture cible conçue pour être mise en place rapidement, afin de valider la faisabilité et la valeur du projet. Elle est centrée sur l'agilité et l'efficacité, en réponse directe aux objectifs du projet "Crésus".

Le flux de la donnée, de sa création à sa consommation, suivra quatre étapes logiques :

=== Étape 1 : Source de Données (Génération & Intégration)

- Le script *Python* génère les données de transactions internes.
- En parallèle, nous récupérons des données de marché externes (ex: historiques de taux de change EUR/USD depuis un fichier CSV).
- Ces deux types de fichiers constituent nos sources de données brutes.

=== Étape 2 : Ingestion & Stockage Centralisé

- Les données internes et externes sont *ingérées et stockées dans une base PostgreSQL*.
- PostgreSQL agit comme *référentiel central* de l'ensemble des données du projet.
- Cette étape permet de structurer, historiser et sécuriser les données tout en facilitant leur réutilisation dans les traitements ultérieurs.

=== Étape 3 : Modélisation Prédictive & Simulation

- Les processus d'analyse et de modélisation sont *orchestrés par Apache Airflow*.
- Chaque tâche du pipeline est représentée sous forme de *DAG (Directed Acyclic Graph)*, garantissant la traçabilité et la reproductibilité du flux complet :
  - Extraction et transformation des données depuis PostgreSQL.
  - Nettoyage et préparation des jeux de données via des scripts Python.
  - Entraînement de modèles prédictifs (ex : prévision des flux de trésorerie à 30 jours).
  - Insertion des résultats des prédictions et simulations dans de nouvelles tables PostgreSQL, prêtes à être visualisées.

#quote[Airflow offre la possibilité d'automatiser et de planifier ces traitements, assurant ainsi un fonctionnement fluide et modulaire.]

=== Étape 4 : Visualisation Interactive et Scénarios

- *Power BI* se connecte directement à *PostgreSQL* pour exploiter les données historiques et prévisionnelles.
- Le tableau de bord est conçu pour être *interactif et dynamique* :
  - *Prévisions :* affichage des positions de trésorerie actuelles et projetées.
  - *Simulation :* l'utilisateur peut ajuster des hypothèses (ex : variation du taux de change EUR/USD) et visualiser en temps réel l'impact sur la trésorerie future.
- Cet outil de restitution permet ainsi une *aide à la décision stratégique*, notamment dans l'élaboration de stratégies de couverture ou d'optimisation de la liquidité.

== Les clients potentiels
<les-clients-potentiels>

#block(
  width: 100%,
  inset: 1em,
  fill: rgb("#eff6ff"),
  radius: 4pt,
  stroke: 1pt + rgb("#bfdbfe"),
  [
    *Utilisateurs principaux :* Les *trésoriers* du groupe et des filiales.

    Ils utiliseront l'outil au quotidien pour piloter la trésorerie opérationnelle sur des tâches telles que le suivi des flux entrants et sortants, la gestion des liquidités dans différentes devises, l'arbitrages de placement et de refinancement. Leur attente principale est d'obtenir une vision centralisée et fiable, avec des alertes et prévisions suffisamment précises pour sécuriser les décisions quotidiennes.
  ]
)

#v(0.5em)

#block(
  width: 100%,
  inset: 1em,
  fill: rgb("#f0fdf4"),
  radius: 4pt,
  stroke: 1pt + rgb("#bbf7d0"),
  [
    *Utilisateurs secondaires :* Le *Directeur Financier* (M. LETANG) et son équipe.

    Ils auront un usage plus stratégique, centré sur la consolidation des données de l'ensemble des filiales, l'élaboration de scénarios de marché (taux, change, stress tests) et la production de reportings avancés. Leur objectif est de disposer d'analyses prédictives robustes pour améliorer la rentabilité et réduire l'exposition aux risques financiers.
  ]
)

#v(0.5em)

#block(
  width: 100%,
  inset: 1em,
  fill: rgb("#fef3c7"),
  radius: 4pt,
  stroke: 1pt + rgb("#fcd34d"),
  [
    *Bénéficiaires finaux :* La *Direction Générale* (M. PAUL).

    Elle attend surtout des synthèses et des indicateurs clés de performance (KPI) afin de mesurer l'efficacité du plan de transformation et de piloter le groupe à un niveau global. L'outil doit lui permettre de disposer rapidement d'une information consolidée, claire et fiable pour orienter les décisions stratégiques (allocation des ressources, investissements, expansion internationale).
  ]
)

== Matrice SWOT
<matrice-swot>

#figure(
  image("SWOT.png", width: 90%),
  caption: [Analyse SWOT du projet Crésus]
)

#v(1em)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #block(
      width: 100%,
      inset: 1em,
      fill: rgb("#dcfce7"),
      radius: 4pt,
      stroke: 1pt + rgb("#86efac"),
      [
        *Forces*
        
        - Présence internationale du groupe (Europe, Afrique, Amérique du Nord) qui favorise la diversité des données financières et apporte une expérience sur différents marchés
        
        - Volonté stratégique claire de moderniser les outils de gestion avec le soutien de la Direction Générale et la Direction Financière, garantissant les moyens mobilisés
        
        - Optimisation multi-devise qui avec la BI prédictive permet de mieux anticiper les flux de trésorerie, réduisant les pertes liées aux fluctuations monétaires
        
        - Données internes riches permettant une étude plus précise et concrète renforçant l'impact de la prise de décision
      ]
    )
  ],
  [
    #block(
      width: 100%,
      inset: 1em,
      fill: rgb("#fee2e2"),
      radius: 4pt,
      stroke: 1pt + rgb("#fca5a5"),
      [
        *Faiblesses*
        
        - Hétérogénéité des systèmes et des données compliquant l'intégration des outils et des pratiques dans une solution unique
        
        - Dépendance à la qualité des données provoquant des analyses prédictives pouvant être biaisées et réduisant ainsi leur valeur ajoutée
        
        - Manque de maturité BI ralentissant l'adoption de ces nouvelles solutions selon les entités
        
        - Investissements élevés demandant des ressources financières, technologiques et humaines importantes au départ
      ]
    )
  ],
  [
    #block(
      width: 100%,
      inset: 1em,
      fill: rgb("#dbeafe"),
      radius: 4pt,
      stroke: 1pt + rgb("#93c5fd"),
      [
        *Opportunités*
        
        - Amélioration de la rentabilité grâce à l'anticipation des flux de trésorerie permettant de placer ou refinancer les liquidités
        
        - Meilleure gestion des risques grâce à l'anticipation des variations des taux d'intérêt et de change
        
        - Avantage concurrentiel en positionnant ZF Banque comme un acteur innovant face aux autres banques
        
        - Intégration de nouvelles technologies offrant des possibilités d'amélioration continue de la solution
      ]
    )
  ],
  [
    #block(
      width: 100%,
      inset: 1em,
      fill: rgb("#fef9c3"),
      radius: 4pt,
      stroke: 1pt + rgb("#fde047"),
      [
        *Menaces*
        
        - Risque de cybersécurité augmenté car le traitement de données sensible est propice aux attaques ciblées et ajoute un risque de fuite de donnée
        
        - Résistance interne au changement car l'adoption de nouveaux outils bouleverse les pratiques des équipes
        
        - Forte concurrence car les autres banques déjà engagées dans la transformation digitale peuvent réduire l'avantage compétitif recherché
      ]
    )
  ]
)

= Notre démarche
<notre-demarche>

Afin d'assurer la réussite du projet Crésus et de répondre à la problématique posée, notre démarche repose sur une organisation progressive autour de quatre axes : cadrage, expérimentation, déploiement et valorisation. Cette approche s'appuie à la fois sur des méthodes classiques et sur l'agilité (sprints de développement et ajustements), garantissant à la fois rigueur et flexibilité.

== Phase 1 — Cadrage et conception
<phase-1-cadrage-et-conception>

Cette phase aura pour objet de préciser les contours du projet, tant attendus sur le plan fonctionnel que technologique. Les actions à mener seront alors :

- *Analyse de l'existant :* recenser les processus de gestion de trésorerie et les sources de données à exploiter (compta, systèmes bancaires, fichiers internes…).

- *Définition du périmètre initial :* choisir les premières filiales puis les devises correspondantes à une première version référente de la solution (e.g. l'Europe et l'Amérique du Nord, en EUR/USD).

- *Conception de l'architecture cible :* choisir les briques technologiques (ETL, data base, plateforme IA, outil de reporting) puis esquisser un schéma cible de flux de données « ingestion → stockage → modélisation → restitution »

== Phase 2 — Preuve de Concept (POC)
<phase-2-preuve-de-concept-poc>

L'enjeu sera de valider rapidement et simplement la faisabilité technique et la valeur métier du projet.

- *Jeu de données :* fabrication ou extraction d'un échantillon de données multi filiales / multi devises, à enrichir éventuellement avec des données marché publiques.

- *Mise en place d'un premier pipeline :* collecte (via un ETL), stockage (Data Lake ou base relationnelle…) puis consommation dans un premier modèle prédictif basique dès lors que nous disposons du jeu de données multi filiales / multi devises.

- *Tableau de bord interactif :* réalisation d'un rapport Power BI mettant en lumière la trésorerie historique, les prévisions à 30 jours, et les premières simulations de scénarios de change.

== Phase 3 — Déploiement et industrialisation
<phase-3-déploiement-et-industrialisation>

Une fois le POC validé, la solution sera étendue progressivement à l'ensemble du groupe.

- *Intégration progressive des filiales et devises :* élargissement du périmètre à toutes les zones géographiques et monnaies utilisées.

- *Renforcement des modèles prédictifs :* passage de modèles simples à des modèles plus sophistiqués (réseaux de neurones, modèles hybrides…).

- *Industrialisation des flux :* mise en place de pipelines de données automatisés, contrôle qualité et gouvernance des données.

- *Sécurisation et conformité :* validation réglementaire (Protection et sécurisation du flux de données, RGPD, lois locales sur la souveraineté des données), cryptage et traçabilité.

== Phase 4 — Restitution finale et valorisation du projet
<phase-4-restitution-finale-et-valorisation-du-projet>

Dans le cadre d'un projet académique, la phase finale ne consiste pas en un déploiement en production ou un plan de transformation organisationnelle, mais en la présentation d'un livrable complet et finalisé qui illustre la faisabilité et la valeur de l'approche choisie. Elle inclut :

- *Complétion du tableau de bord Power BI :* fournir un rapport interactif qui permet d'examiner l'historique et les prévisions de trésorerie, en intégrant des scénarios simulés (comme les fluctuations du taux de change EUR/USD, les retards de paiement des clients.

- *Structuration de l'architecture cible :* proposer un diagramme explicite et pédagogique des flux de données (sources → ETL → stockage → modélisation → présentation). Le but est de démontrer l'harmonie globale et la coordination efficace entre les instruments sélectionnés (par exemple : Talend / PostgreSQL / Azure ML / Power BI).

- *Présentation orale (défense) :* élaborer un support détaillant le déroulement du projet, les décisions technologiques prises, les résultats affichés sur le tableau de bord, et les horizons d'évolution possibles.

= Annexe
<annexe>

== Références bibliographiques

- Banque de France : L'accord de Bâle III, Mis en ligne le 23 Avril 2025.

- International Journal of Research Publication and Reviews - Predictive Analytics in Financial Management: Enhancing Decision-Making and Risk Management. Opeyemi E.Aro

- Blurred lines: How FinTech is shaping Financial Services - Global FinTech Report, Mars 2016

== Documentation technique

- Talend — Documentation officielle (Open Studio, Data Integration) : #link("https://help.talend.com/")

- Apache Airflow — Documentation officielle : #link("https://airflow.apache.org/docs/")

- PostgreSQL — Documentation officielle : #link("https://www.postgresql.org/docs/current/index.html")

- PowerBI — Documentation officielle : #link("https://learn.microsoft.com/fr-fr/power-bi/")

== Schémas et illustrations

#figure(
  image("Star schema.png", width: 80%),
  caption: [Exemple d'architecture Data Warehouse - Altexsoft]
)

#v(1em)

#figure(
  image("Bale 3.png", width: 80%),
  caption: [Piliers de l'accord de Bâle III]
)

#v(1em)

#figure(
  image("Bale 4.png", width: 80%),
  caption: [Principales évolutions dans l'accord Bâle IV]
)
