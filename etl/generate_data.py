"""
Script de génération de données synthétiques pour le POC Crésus
Génère les fichiers CSV sources pour les dimensions et la table de faits
Période : 2-3 ans d'historique (2022-2024)
"""

import csv
import random
from datetime import datetime, timedelta
from pathlib import Path

# Configuration
DATA_DIR = Path("data/sources")
DATA_DIR.mkdir(parents=True, exist_ok=True)

# Période de génération : 2-3 ans (du 1er janvier 2022 au 31 décembre 2024)
START_DATE = datetime(2022, 1, 1)
END_DATE = datetime(2024, 12, 31)

# Seed pour reproductibilité
random.seed(42)


def generate_dim_filiale():
    """Génère la dimension Filiale"""
    filiales = [
        {"nom_filiale": "ZF Banque France", "pays": "France", "region": "Europe"},
        {"nom_filiale": "ZF Banque Allemagne", "pays": "Allemagne", "region": "Europe"},
        {"nom_filiale": "ZF Banque UK", "pays": "Royaume-Uni", "region": "Europe"},
        {"nom_filiale": "ZF Banque Suisse", "pays": "Suisse", "region": "Europe"},
        {"nom_filiale": "ZF Banque Espagne", "pays": "Espagne", "region": "Europe"},
        {"nom_filiale": "ZF Banque Italie", "pays": "Italie", "region": "Europe"},
    ]
    
    with open(DATA_DIR / "dim_filiale.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id_filiale", "nom_filiale", "pays", "region"])
        writer.writeheader()
        for idx, filiale in enumerate(filiales, start=1):
            writer.writerow({
                "id_filiale": idx,
                "nom_filiale": filiale["nom_filiale"],
                "pays": filiale["pays"],
                "region": filiale["region"]
            })
    print(f"[OK] Généré dim_filiale.csv ({len(filiales)} lignes)")


def generate_dim_devise():
    """Génère la dimension Devise"""
    devises = [
        {"code_iso": "EUR", "libelle_devise": "Euro"},
        {"code_iso": "USD", "libelle_devise": "Dollar américain"},
        {"code_iso": "GBP", "libelle_devise": "Livre sterling"},
        {"code_iso": "CHF", "libelle_devise": "Franc suisse"},
    ]
    
    with open(DATA_DIR / "dim_devise.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id_devise", "code_iso", "libelle_devise"])
        writer.writeheader()
        for idx, devise in enumerate(devises, start=1):
            writer.writerow({
                "id_devise": idx,
                "code_iso": devise["code_iso"],
                "libelle_devise": devise["libelle_devise"]
            })
    print(f"[OK] Généré dim_devise.csv ({len(devises)} lignes)")
    return devises


def generate_dim_scenario():
    """Génère la dimension Scénario"""
    scenarios = [
        {"nom_scenario": "Réalisé", "description": "Données historiques réelles"},
        {"nom_scenario": "Prévisionnel", "description": "Prévisions basées sur le modèle prédictif"},
        {"nom_scenario": "Simulation Taux +1%", "description": "Simulation avec augmentation de 1% des taux"},
    ]
    
    with open(DATA_DIR / "dim_scenario.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id_scenario", "nom_scenario", "description"])
        writer.writeheader()
        for idx, scenario in enumerate(scenarios, start=1):
            writer.writerow({
                "id_scenario": idx,
                "nom_scenario": scenario["nom_scenario"],
                "description": scenario["description"]
            })
    print(f"[OK] Généré dim_scenario.csv ({len(scenarios)} lignes)")
    return scenarios


def generate_dim_contrepartie():
    """Génère la dimension Contrepartie"""
    contreparties = []
    types_contrepartie = ["Client", "Fournisseur", "Banque partenaire", "Institution financière"]
    
    # Clients
    for i in range(1, 21):
        contreparties.append({
            "nom_contrepartie": f"Client Entreprise {i:03d}",
            "type_contrepartie": "Client"
        })
    
    # Fournisseurs
    for i in range(1, 16):
        contreparties.append({
            "nom_contrepartie": f"Fournisseur {i:03d}",
            "type_contrepartie": "Fournisseur"
        })
    
    # Banques partenaires
    banques = ["BNP Paribas", "Société Générale", "Crédit Agricole", "Deutsche Bank", "HSBC", "UBS"]
    for banque in banques:
        contreparties.append({
            "nom_contrepartie": banque,
            "type_contrepartie": "Banque partenaire"
        })
    
    # Institutions financières
    institutions = ["Banque Centrale Européenne", "FMI", "Banque Mondiale"]
    for inst in institutions:
        contreparties.append({
            "nom_contrepartie": inst,
            "type_contrepartie": "Institution financière"
        })
    
    with open(DATA_DIR / "dim_contrepartie.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id_contrepartie", "nom_contrepartie", "type_contrepartie"])
        writer.writeheader()
        for idx, contrepartie in enumerate(contreparties, start=1):
            writer.writerow({
                "id_contrepartie": idx,
                "nom_contrepartie": contrepartie["nom_contrepartie"],
                "type_contrepartie": contrepartie["type_contrepartie"]
            })
    print(f"[OK] Généré dim_contrepartie.csv ({len(contreparties)} lignes)")
    return contreparties


def generate_dim_compte(num_filiales, num_devises):
    """Génère la dimension Compte"""
    comptes = []
    types_compte = ["Compte courant", "Compte épargne", "Compte professionnel", "Compte de trésorerie"]
    
    # Générer 3-5 comptes par filiale et par devise
    compte_id = 1
    for filiale_id in range(1, num_filiales + 1):
        for devise_id in range(1, num_devises + 1):
            num_comptes_filiale_devise = random.randint(3, 5)
            for _ in range(num_comptes_filiale_devise):
                # Générer un numéro de compte IBAN-like
                pays_code = random.choice(["FR", "DE", "GB", "CH", "ES", "IT"])
                numero = f"{pays_code}{random.randint(10, 99)} {random.randint(1000, 9999)} {random.randint(1000, 9999)} {random.randint(1000, 9999)} {random.randint(1000, 9999)} {random.randint(10, 99)}"
                
                comptes.append({
                    "id_compte": compte_id,
                    "numero_compte": numero,
                    "type_compte": random.choice(types_compte),
                    "id_devise": devise_id,
                    "id_filiale": filiale_id
                })
                compte_id += 1
    
    with open(DATA_DIR / "dim_compte.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id_compte", "numero_compte", "type_compte", "id_devise", "id_filiale"])
        writer.writeheader()
        for compte in comptes:
            writer.writerow(compte)
    print(f"[OK] Généré dim_compte.csv ({len(comptes)} lignes)")
    return comptes


def generate_dim_temps():
    """Génère la dimension Temps"""
    temps_records = []
    current_date = START_DATE
    id_temps = 1
    
    while current_date <= END_DATE:
        temps_records.append({
            "id_temps": id_temps,
            "jour": current_date.day,
            "mois": current_date.month,
            "annee": current_date.year
        })
        current_date += timedelta(days=1)
        id_temps += 1
    
    with open(DATA_DIR / "dim_temps.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id_temps", "jour", "mois", "annee"])
        writer.writeheader()
        for record in temps_records:
            writer.writerow(record)
    print(f"[OK] Généré dim_temps.csv ({len(temps_records)} lignes)")
    return temps_records


def generate_taux_de_change():
    """Génère l'historique des taux de change"""
    taux_records = []
    current_date = START_DATE
    
    # Taux de base (approximatifs)
    taux_base = {
        ("EUR", "USD"): 1.10,
        ("EUR", "GBP"): 0.85,
        ("EUR", "CHF"): 1.05,
        ("USD", "EUR"): 0.91,
        ("GBP", "EUR"): 1.18,
        ("CHF", "EUR"): 0.95,
    }
    
    # Codes ISO des devises
    devises_codes = ["EUR", "USD", "GBP", "CHF"]
    
    while current_date <= END_DATE:
        # Générer des taux avec une légère variation quotidienne (±0.5%)
        for source in devises_codes:
            for cible in devises_codes:
                if source != cible:
                    if (source, cible) in taux_base:
                        base_taux = taux_base[(source, cible)]
                    else:
                        # Calculer taux inverse ou croisé
                        if (cible, source) in taux_base:
                            base_taux = 1 / taux_base[(cible, source)]
                        else:
                            continue
                    
                    # Variation aléatoire quotidienne
                    variation = random.uniform(-0.005, 0.005)
                    taux = base_taux * (1 + variation)
                    
                    taux_records.append({
                        "date": current_date.strftime("%Y-%m-%d"),
                        "code_iso_source": source,
                        "code_iso_cible": cible,
                        "taux": round(taux, 6)
                    })
        
        current_date += timedelta(days=1)
    
    with open(DATA_DIR / "taux_de_change.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["date", "code_iso_source", "code_iso_cible", "taux"])
        writer.writeheader()
        for record in taux_records:
            writer.writerow(record)
    print(f"[OK] Généré taux_de_change.csv ({len(taux_records)} lignes)")
    return taux_records


def generate_fact_flux_tresorerie(comptes, temps_records, num_contreparties):
    """Génère la table de faits FACT_FLUX_TRESORERIE avec des données réalistes"""
    flux_records = []
    
    # Configuration des opérations : Poids, Signe (+/-), Plages de montants, Mode (pour distribution triangulaire)
    ops_config = [
        # Opérations courantes (flux réguliers)
        {"type": "Virement émis",        "sign": -1, "weight": 30, "min": 100,    "max": 150000,  "mode": 2500},   # Paiements fournisseurs, charges...
        {"type": "Virement reçu",        "sign": 1,  "weight": 30, "min": 100,    "max": 200000,  "mode": 5000},   # Paiements clients
        
        # Opérations de guichet
        {"type": "Dépôt",                "sign": 1,  "weight": 10, "min": 500,    "max": 50000,   "mode": 2000},
        {"type": "Retrait",              "sign": -1, "weight": 5,  "min": 50,     "max": 3000,    "mode": 200},
        
        # Opérations de financement (Montants importants, plus rares)
        {"type": "Prêt",                 "sign": 1,  "weight": 1,  "min": 100000, "max": 5000000, "mode": 500000}, # Déblocage de fonds
        {"type": "Remboursement prêt",   "sign": -1, "weight": 5,  "min": 1000,   "max": 50000,   "mode": 5000},   # Échéances
        
        # Frais et intérêts (Petits montants, fréquents ou périodiques)
        {"type": "Frais bancaires",      "sign": -1, "weight": 15, "min": 10,     "max": 500,     "mode": 30},
        {"type": "Intérêts créditeurs",  "sign": 1,  "weight": 2,  "min": 50,     "max": 5000,    "mode": 200},    # Placements
        {"type": "Intérêts débiteurs",   "sign": -1, "weight": 2,  "min": 50,     "max": 10000,   "mode": 500},    # Agios, découverts
    ]
    
    # Préparation des poids et types pour random.choices
    types_list = [op["type"] for op in ops_config]
    weights_list = [op["weight"] for op in ops_config]
    config_map = {op["type"]: op for op in ops_config}

    statuts = ["Réalisé", "Prévisionnel"]
    
    # Générer environ 5000 transactions sur la période
    num_transactions = 5000
    
    # Créer un dictionnaire pour mapper date -> id_temps
    date_to_id_temps = {}
    for temps in temps_records:
        date_key = f"{temps['annee']}-{temps['mois']:02d}-{temps['jour']:02d}"
        date_to_id_temps[date_key] = temps['id_temps']
    
    for _ in range(num_transactions):
        # Date aléatoire dans la période
        days_offset = random.randint(0, (END_DATE - START_DATE).days)
        date_operation = START_DATE + timedelta(days=days_offset)
        date_key = date_operation.strftime("%Y-%m-%d")
        
        if date_key not in date_to_id_temps:
            continue
        
        id_temps = date_to_id_temps[date_key]
        
        # Sélectionner un compte aléatoire
        compte = random.choice(comptes)
        id_compte = compte['id_compte']
        id_devise = compte['id_devise']
        
        # Sélectionner un type d'opération pondéré
        type_operation = random.choices(types_list, weights=weights_list, k=1)[0]
        op_cfg = config_map[type_operation]
        
        # Générer un montant réaliste (distribution triangulaire)
        base_amount = random.triangular(op_cfg["min"], op_cfg["max"], op_cfg["mode"])
        montant_transaction = round(base_amount * op_cfg["sign"], 2)
        
        # Statut (majoritairement Réalisé pour l'historique)
        # Les dates futures par rapport à aujourd'hui devraient être prévisionnelles, mais ici on simule un historique complet
        # On garde la logique aléatoire simple pour l'instant
        statut = random.choices(statuts, weights=[90, 10])[0]
        
        # Scénario (1 = Réalisé pour la plupart)
        id_scenario = 1 if statut == "Réalisé" else random.choice([2, 3])
        
        # Contrepartie aléatoire
        id_contrepartie = random.randint(1, num_contreparties)
        
        flux_records.append({
            "date_operation": date_key,
            "montant_transaction": montant_transaction,
            "montant_consolide_eur": None,  # Sera calculé dans le pipeline ETL
            "type_operation": type_operation,
            "statut": statut,
            "id_compte": id_compte,
            "id_devise": id_devise,
            "id_scenario": id_scenario,
            "id_temps": id_temps,
            "id_contrepartie": id_contrepartie
        })
    
    with open(DATA_DIR / "fact_flux_tresorerie.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=[
            "date_operation", "montant_transaction", "montant_consolide_eur",
            "type_operation", "statut", "id_compte", "id_devise",
            "id_scenario", "id_temps", "id_contrepartie"
        ])
        writer.writeheader()
        for record in flux_records:
            writer.writerow(record)
    print(f"[OK] Généré fact_flux_tresorerie.csv ({len(flux_records)} lignes) avec logique réaliste")


def main():
    """Fonction principale"""
    print("=" * 60)
    print("Génération des données sources pour le POC Crésus")
    print("=" * 60)
    
    # Générer les dimensions
    generate_dim_filiale()
    generate_dim_devise()
    generate_dim_scenario()
    contreparties = generate_dim_contrepartie()
    temps_records = generate_dim_temps()
    
    # Générer DIM_COMPTE (nécessite les dimensions filiale et devise)
    num_filiales = 6
    num_devises = 4
    comptes = generate_dim_compte(num_filiales, num_devises)
    
    # Générer les données externes
    generate_taux_de_change()
    
    # Générer la table de faits
    generate_fact_flux_tresorerie(comptes, temps_records, len(contreparties))
    
    print("=" * 60)
    print("[OK] Génération terminée avec succès!")
    print(f"[OK] Fichiers générés dans : {DATA_DIR}")
    print("=" * 60)


if __name__ == "__main__":
    main()

