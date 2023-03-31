/*
 SAE Velos de nantes - Script de création des tables
 Technologie : MySQL
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Matéo
 PITON Corentin
 PIERRE Noé
 
 ==================== Script de création des tables ====================
 */
-- ===== Suppression des tables =====
DROP TABLE IF EXISTS ReleveJournalier;
DROP TABLE IF EXISTS Jour;
DROP TABLE IF EXISTS Compteur;
DROP TABLE IF EXISTS Quartier;

-- ===== Création des tables =====
CREATE TABLE Quartier (
    code INT PRIMARY KEY,
    nom VARCHAR(100),
    longueurPiste INT CHECK (longueurPiste >= 0)
);

CREATE TABLE Compteur (
    numero INT PRIMARY KEY,
    libelle VARCHAR(100),
    observations VARCHAR(100),
    longitude DECIMAL(20, 18),
    latitude DECIMAL(20, 18),
    leQuartier INT,
    CONSTRAINT fk_Compteur_Quartier FOREIGN KEY (leQuartier) REFERENCES Quartier(code)
);

CREATE TABLE Jour (
    jourDate DATE PRIMARY KEY,
    jourDeSemaine INT CHECK (
        jourDeSemaine >= 1
        AND jourDeSemaine <= 7
    ),
    vacancesZoneB VARCHAR(100) CHECK (
        vacancesZoneB IN (
            'Hors Vacances',
            'Pont de l''Ascension',
            'Vacances d''été',
            'Vacances de la Toussaint',
            'Vacances de Noël',
            'Vacances de printemps',
            'Vacances d''hiver'
        )
    ),
    temperature DECIMAL(5, 2)
);

CREATE TABLE ReleveJournalier (
    leCompteur INT,
    leJour DATE,
    heure0 INT CHECK (heure0 >= 0),
    heure1 INT CHECK (heure1 >= 0),
    heure2 INT CHECK (heure2 >= 0),
    heure3 INT CHECK (heure3 >= 0),
    heure4 INT CHECK (heure4 >= 0),
    heure5 INT CHECK (heure5 >= 0),
    heure6 INT CHECK (heure6 >= 0),
    heure7 INT CHECK (heure7 >= 0),
    heure8 INT CHECK (heure8 >= 0),
    heure9 INT CHECK (heure9 >= 0),
    heure10 INT CHECK (heure10 >= 0),
    heure11 INT CHECK (heure11 >= 0),
    heure12 INT CHECK (heure12 >= 0),
    heure13 INT CHECK (heure13 >= 0),
    heure14 INT CHECK (heure14 >= 0),
    heure15 INT CHECK (heure15 >= 0),
    heure16 INT CHECK (heure16 >= 0),
    heure17 INT CHECK (heure17 >= 0),
    heure18 INT CHECK (heure18 >= 0),
    heure19 INT CHECK (heure19 >= 0),
    heure20 INT CHECK (heure20 >= 0),
    heure21 INT CHECK (heure21 >= 0),
    heure22 INT CHECK (heure22 >= 0),
    heure23 INT CHECK (heure23 >= 0),
    total INT CHECK (total >= 0),
    probabiliteAnomalie VARCHAR(10) CHECK (
        probabiliteAnomalie IN ('Faible', 'Moyenne', 'Forte')
    ),
    CONSTRAINT PRIMARY KEY (leCompteur, leJour),
    CONSTRAINT fk_ReleveJournalier_Compteur FOREIGN KEY (leCompteur) REFERENCES Compteur(numero),
    CONSTRAINT fk_ReleveJournalier_Jour FOREIGN KEY (leJour) REFERENCES Jour(jourDate)
);
