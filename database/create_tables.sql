-- =====================================================
-- Script de création de la base de données PostgreSQL
-- Projet Crésus - POC BI Prédictive Trésorerie
-- Modèle en flocon (Snowflake Schema)
-- =====================================================

-- Suppression des tables si elles existent (dans l'ordre inverse des dépendances)
DROP TABLE IF EXISTS FACT_FLUX_TRESORERIE CASCADE;
DROP TABLE IF EXISTS DIM_COMPTE CASCADE;
DROP TABLE IF EXISTS DIM_TEMPS CASCADE;
DROP TABLE IF EXISTS DIM_SCENARIO CASCADE;
DROP TABLE IF EXISTS DIM_DEVISE CASCADE;
DROP TABLE IF EXISTS DIM_FILIALE CASCADE;
DROP TABLE IF EXISTS DIM_CONTREPARTIE CASCADE;

-- =====================================================
-- TABLES DE DIMENSIONS
-- =====================================================

-- Dimension Temps
CREATE TABLE DIM_TEMPS (
    id_temps SERIAL PRIMARY KEY,
    jour INTEGER NOT NULL,
    mois INTEGER NOT NULL,
    annee INTEGER NOT NULL,
    CONSTRAINT chk_jour CHECK (jour >= 1 AND jour <= 31),
    CONSTRAINT chk_mois CHECK (mois >= 1 AND mois <= 12),
    CONSTRAINT chk_annee CHECK (annee >= 2020 AND annee <= 2030)
);

-- Dimension Scénario
CREATE TABLE DIM_SCENARIO (
    id_scenario SERIAL PRIMARY KEY,
    nom_scenario VARCHAR(255) NOT NULL,
    description TEXT
);

-- Dimension Devise
CREATE TABLE DIM_DEVISE (
    id_devise SERIAL PRIMARY KEY,
    code_iso VARCHAR(3) NOT NULL UNIQUE,
    libelle_devise VARCHAR(100)
);

-- Dimension Filiale
CREATE TABLE DIM_FILIALE (
    id_filiale SERIAL PRIMARY KEY,
    nom_filiale VARCHAR(255) NOT NULL,
    pays VARCHAR(100),
    region VARCHAR(100)
);

-- Dimension Contrepartie
CREATE TABLE DIM_CONTREPARTIE (
    id_contrepartie SERIAL PRIMARY KEY,
    nom_contrepartie VARCHAR(255) NOT NULL,
    type_contrepartie VARCHAR(100)
);

-- Dimension Compte (avec références vers DIM_DEVISE et DIM_FILIALE)
CREATE TABLE DIM_COMPTE (
    id_compte SERIAL PRIMARY KEY,
    numero_compte VARCHAR(100) NOT NULL,
    type_compte VARCHAR(100),
    id_devise INTEGER NOT NULL,
    id_filiale INTEGER NOT NULL,
    FOREIGN KEY (id_devise) REFERENCES DIM_DEVISE(id_devise),
    FOREIGN KEY (id_filiale) REFERENCES DIM_FILIALE(id_filiale)
);

-- =====================================================
-- TABLE DE FAITS
-- =====================================================

CREATE TABLE FACT_FLUX_TRESORERIE (
    id_flux SERIAL PRIMARY KEY,
    date_operation DATE NOT NULL,
    montant_transaction NUMERIC(15, 2) NOT NULL,
    montant_consolide_eur NUMERIC(15, 2),
    type_operation VARCHAR(100),
    statut VARCHAR(50),
    id_compte INTEGER NOT NULL,
    id_devise INTEGER NOT NULL,
    id_scenario INTEGER NOT NULL,
    id_temps INTEGER NOT NULL,
    id_contrepartie INTEGER NOT NULL,
    FOREIGN KEY (id_compte) REFERENCES DIM_COMPTE(id_compte),
    FOREIGN KEY (id_devise) REFERENCES DIM_DEVISE(id_devise),
    FOREIGN KEY (id_scenario) REFERENCES DIM_SCENARIO(id_scenario),
    FOREIGN KEY (id_temps) REFERENCES DIM_TEMPS(id_temps),
    FOREIGN KEY (id_contrepartie) REFERENCES DIM_CONTREPARTIE(id_contrepartie)
);

-- =====================================================
-- INDEX POUR OPTIMISATION DES REQUÊTES
-- =====================================================

CREATE INDEX idx_fact_date_operation ON FACT_FLUX_TRESORERIE(date_operation);
CREATE INDEX idx_fact_statut ON FACT_FLUX_TRESORERIE(statut);
CREATE INDEX idx_fact_type_operation ON FACT_FLUX_TRESORERIE(type_operation);
CREATE INDEX idx_fact_id_scenario ON FACT_FLUX_TRESORERIE(id_scenario);
CREATE INDEX idx_dim_temps_date ON DIM_TEMPS(annee, mois, jour);
CREATE INDEX idx_dim_compte_numero ON DIM_COMPTE(numero_compte);

-- =====================================================
-- COMMENTAIRES SUR LES TABLES
-- =====================================================

COMMENT ON TABLE FACT_FLUX_TRESORERIE IS 'Table de faits contenant les flux de trésorerie';
COMMENT ON TABLE DIM_TEMPS IS 'Dimension temporelle pour l''analyse des flux';
COMMENT ON TABLE DIM_SCENARIO IS 'Dimension des scénarios (Réalisé, Prévisionnel, Simulations)';
COMMENT ON TABLE DIM_DEVISE IS 'Dimension des devises';
COMMENT ON TABLE DIM_FILIALE IS 'Dimension des filiales du groupe ZF Banque';
COMMENT ON TABLE DIM_COMPTE IS 'Dimension des comptes bancaires';
COMMENT ON TABLE DIM_CONTREPARTIE IS 'Dimension des contreparties (clients, fournisseurs, etc.)';

