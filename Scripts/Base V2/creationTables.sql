/*
 SAE Velos de nantes - Script de création des tables V2
 
 ==================== Description ===================
 Shema relationnel de la base de donnée avec les améliorations de la question 4.
 Technologie : MySQL
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Mattéo
 PITON Corentin
 PIERRE Noé
 
 ==================== Script de création des tables V2 ====================
 */
-- ===== Suppression des tables =====
DROP TABLE IF EXISTS FiltreCompteur;
DROP TABLE IF EXISTS CalqueJour;
DROP TABLE IF EXISTS CalqueFavori;
DROP TABLE IF EXISTS Filtre;
DROP TABLE IF EXISTS Favori;
DROP TABLE IF EXISTS Calque;
DROP TABLE IF EXISTS Compte;
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
    direction VARCHAR(100),
    observations VARCHAR(100),
    longitude DECIMAL(20, 18),
    latitude DECIMAL(20, 18),
    leQuartier INT,
    CONSTRAINT fk_Compteur_Quartier FOREIGN KEY (leQuartier) REFERENCES Quartier(code)
);

CREATE TABLE Jour (
    jourDate DATE PRIMARY KEY,
    jourDeSemaine INT CHECK (
        jourDeSemaine > 0
        AND jourDeSemaine < 8
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
    probabiliteAnomalie VARCHAR(10) CHECK (
        probabiliteAnomalie IN ('Faible', 'Moyenne', 'Forte')
    ),
    CONSTRAINT PRIMARY KEY (leCompteur, leJour),
    CONSTRAINT fk_ReleveJournalier_Compteur FOREIGN KEY (leCompteur) REFERENCES Compteur(numero),
    CONSTRAINT fk_ReleveJournalier_Jour FOREIGN KEY (leJour) REFERENCES Jour(jourDate)
);

CREATE TABLE Compte (
    idCompte INT PRIMARY KEY AUTO_INCREMENT,
    identifiant VARCHAR(100) NOT NULL UNIQUE,
    motDePasse VARCHAR(255) NOT NULL,
    typeDeCompte VARCHAR(30) CHECK (
        typeDeCompte IN ('Public', 'Utilisateur', 'Elu', 'Administrateur')
    )
);

CREATE TABLE Favori (
    idFavori INT PRIMARY KEY AUTO_INCREMENT,
    nomFavori VARCHAR(100),
    leCompte INT,
    CONSTRAINT fk_Favori_Compte FOREIGN KEY (leCompte) REFERENCES Compte(idCompte)
);

CREATE TABLE Calque (
    idCalque INT PRIMARY KEY AUTO_INCREMENT,
    nomCalque VARCHAR(100)
);

CREATE TABLE Filtre (
    idFiltre INT PRIMARY KEY AUTO_INCREMENT,
    typeCalcul VARCHAR(20) NOT NULL CHECK (
        typeCalcul IN ('Somme', 'Moyenne', 'Somme des sommes', 'Moyenne des sommes')
    ),
    typeRegroupement VARCHAR(20) NOT NULL CHECK (
        typeRegroupement IN ('Heure', 'Jour', 'Semaine', 'Mois', 'Annee')
    ),
    typeGraphique VARCHAR(20) NOT NULL CHECK (
        typeGraphique IN ('Courbe', 'Histogramme')
    ),
    ordre INT NOT NULL CHECK (
        ordre >= 1
        AND ordre <= 5
    ),
    dateDebut DATE NOT NULL,
    dateFin DATE,
    leFavori INT NOT NULL,
    CONSTRAINT fk_Filtre_Favori FOREIGN KEY (leFavori) REFERENCES Favori(idFavori),
    CONSTRAINT dateInf CHECK (dateFin >= dateDebut)
);

CREATE TABLE FiltreCompteur (
    leFiltre INT NOT NULL,
    leCompteur INT NOT NULL,
    CONSTRAINT PRIMARY KEY (leFiltre, leCompteur),
    CONSTRAINT fk_FiltreCompteur_Filtre FOREIGN KEY (leFiltre) REFERENCES Filtre(idFiltre),
    CONSTRAINT fk_FiltreCompteur_Compteur FOREIGN KEY (leCompteur) REFERENCES Compteur(numero)
);

CREATE TABLE CalqueJour (
    leCalque INT NOT NULL,
    leJour DATE NOT NULL,
    CONSTRAINT PRIMARY KEY (leCalque, leJour),
    CONSTRAINT fk_CalqueJour_Calque FOREIGN KEY (leCalque) REFERENCES Calque(idCalque),
    CONSTRAINT fk_CalqueJour_Jour FOREIGN KEY (leJour) REFERENCES Jour(jourDate)
);

CREATE TABLE CalqueFavori (
    leCalque INT NOT NULL,
    leFavori INT NOT NULL,
    CONSTRAINT PRIMARY KEY (leCalque, leFavori),
    CONSTRAINT fk_CalqueFavori_Calque FOREIGN KEY (leCalque) REFERENCES Calque(idCalque),
    CONSTRAINT fk_CalqueFavori_Favori FOREIGN KEY (leFavori) REFERENCES Favori(idFavori)
);