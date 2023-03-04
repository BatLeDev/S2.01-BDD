/*
 SAE Velos de nantes - Script de création des tables
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Mattéo
 PITON Corentin
 PIERRE Noé
 
 ==================== Script de création des tables ====================
*/

-- ===== Surpession des tables =====
DROP TABLE ReleveJournalier;
DROP TABLE Jour;
DROP TABLE Compteur;
DROP TABLE Quartier;

-- ===== Création des tables =====

CREATE TABLE Quartier (
    code NUMBER CONSTRAINT pk_Quartier PRIMARY KEY,
    nom VARCHAR2(100),
    longueurPiste NUMBER
);

CREATE TABLE Compteur (
    numero NUMBER CONSTRAINT pk_Compteur PRIMARY KEY,
    libelle VARCHAR2(100),
    longitude DECIMAL(18,15),
    latitude DECIMAL(18, 15),
    leQuartier NUMBER CONSTRAINT fk_Compteur_Quartier REFERENCES Quartier(code)
);

CREATE TABLE Jour (
    jour DATE CONSTRAINT pk_Jour PRIMARY KEY,
    jourDeSemaine NUMBER
        CONSTRAINT ck_jourDeSemaine CHECK (jourDeSemaine >= 1 AND jourDeSemaine <= 7) 
        CONSTRAINT nn_jourDeSemaine NOT NULL,
    vacancesZoneB VARCHAR2(100)
        CONSTRAINT ck_vacancesZoneB CHECK (vacancesZoneB IN ('Hors Vacances', 'Pont de l''Ascension', 'Vacances d''été', 'Vacances de la Toussaint', 'Vacances de Noël', 'Vacances de printemps', 'Vacances d''hiver'))
);

CREATE TABLE ReleveJournalier (
    leCompteur NUMBER 
        CONSTRAINT fk_ReleveJournalier_Compteur REFERENCES Compteur(numero)
        CONSTRAINT uq_leCompteur UNIQUE,
    leJour DATE 
        CONSTRAINT fk_ReleveJournalier_Jour REFERENCES Jour(jour)
        CONSTRAINT uq_leJour UNIQUE,
    heure0 NUMBER
        CONSTRAINT ck_heure0 CHECK (heure0 >= 0),
    heure1 NUMBER
        CONSTRAINT ck_heure1 CHECK (heure1 >= 0),
    heure2 NUMBER
        CONSTRAINT ck_heure2 CHECK (heure2 >= 0),
    heure3 NUMBER
        CONSTRAINT ck_heure3 CHECK (heure3 >= 0),
    heure4 NUMBER
        CONSTRAINT ck_heure4 CHECK (heure4 >= 0),
    heure5 NUMBER
        CONSTRAINT ck_heure5 CHECK (heure5 >= 0),
    heure6 NUMBER
        CONSTRAINT ck_heure6 CHECK (heure6 >= 0),
    heure7 NUMBER
        CONSTRAINT ck_heure7 CHECK (heure7 >= 0),
    heure8 NUMBER
        CONSTRAINT ck_heure8 CHECK (heure8 >= 0),
    heure9 NUMBER
        CONSTRAINT ck_heure9 CHECK (heure9 >= 0),
    heure10 NUMBER
        CONSTRAINT ck_heure10 CHECK (heure10 >= 0),
    heure11 NUMBER
        CONSTRAINT ck_heure11 CHECK (heure11 >= 0),
    heure12 NUMBER
        CONSTRAINT ck_heure12 CHECK (heure12 >= 0),
    heure13 NUMBER
        CONSTRAINT ck_heure13 CHECK (heure13 >= 0),
    heure14 NUMBER
        CONSTRAINT ck_heure14 CHECK (heure14 >= 0),
    heure15 NUMBER
        CONSTRAINT ck_heure15 CHECK (heure15 >= 0),
    heure16 NUMBER
        CONSTRAINT ck_heure16 CHECK (heure16 >= 0),
    heure17 NUMBER
        CONSTRAINT ck_heure17 CHECK (heure17 >= 0),
    heure18 NUMBER
        CONSTRAINT ck_heure18 CHECK (heure18 >= 0),
    heure19 NUMBER
        CONSTRAINT ck_heure19 CHECK (heure19 >= 0),
    heure20 NUMBER
        CONSTRAINT ck_heure20 CHECK (heure20 >= 0),
    heure21 NUMBER
        CONSTRAINT ck_heure21 CHECK (heure21 >= 0),
    heure22 NUMBER
        CONSTRAINT ck_heure22 CHECK (heure22 >= 0),
    heure23 NUMBER
        CONSTRAINT ck_heure23 CHECK (heure23 >= 0),
    total NUMBER
        CONSTRAINT ck_total CHECK (total >= 0),
    probabiliteAnomalie VARCHAR2(10)
        CONSTRAINT ck_probabiliteAnomalie CHECK (probabiliteAnomalie IN ('Faible', 'Moyenne', 'Forte')),
    CONSTRAINT pk_ReleveJournalier PRIMARY KEY (leCompteur, leJour)
);