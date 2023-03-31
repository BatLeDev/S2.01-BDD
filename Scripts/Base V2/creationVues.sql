/*
 SAE Velos de nantes - Script de création de vues
 Technologie : MySQL
 
 ============= Description =============
 Nous avons choisit de créé des vues qui permettent de 
 - gérer les attributs dérivés
 - simplifier certaines requêtes
 - tester des contraintes de la base de données

 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Matteo
 PITON Corentin
 PIERRE Noe
 */
--==================== Script de création de vues ====================

-- 1. Gestion des attributs dérivés
-- 1.1. Affichier pour chaque compteur la date, le nombre total de passage par jour, 
--      l'heure de la journée avec le plus de passage avec ce nombre de passage, la probabilité d'anomalie
CREATE OR REPLACE VIEW vue_ReleveJournalierResume AS
    SELECT leCompteur, leJour, probabiliteAnomalie,
        -- Nombre total de passage par jour
        heure0 + heure1 + heure2 + heure3 + heure4 + heure5 + heure6 + heure7 + heure8 + heure9 + heure10 + heure11 + heure12 + 
        heure13 + heure14 + heure15 + heure16 + heure17 + heure18 + heure19 + heure20 + heure21 + heure22 + heure23 AS total,

        -- Heure avec le plus de passage
        CASE
            WHEN heure0 = freqHeureMax THEN 0
            WHEN heure1 = freqHeureMax THEN 1
            WHEN heure2 = freqHeureMax THEN 2
            WHEN heure3 = freqHeureMax THEN 3
            WHEN heure4 = freqHeureMax THEN 4
            WHEN heure5 = freqHeureMax THEN 5
            WHEN heure6 = freqHeureMax THEN 6
            WHEN heure7 = freqHeureMax THEN 7
            WHEN heure8 = freqHeureMax THEN 8
            WHEN heure9 = freqHeureMax THEN 9
            WHEN heure10 = freqHeureMax THEN 10
            WHEN heure11 = freqHeureMax THEN 11
            WHEN heure12 = freqHeureMax THEN 12
            WHEN heure13 = freqHeureMax THEN 13
            WHEN heure14 = freqHeureMax THEN 14
            WHEN heure15 = freqHeureMax THEN 15
            WHEN heure16 = freqHeureMax THEN 16
            WHEN heure17 = freqHeureMax THEN 17
            WHEN heure18 = freqHeureMax THEN 18
            WHEN heure19 = freqHeureMax THEN 19
            WHEN heure20 = freqHeureMax THEN 20
            WHEN heure21 = freqHeureMax THEN 21
            WHEN heure22 = freqHeureMax THEN 22
            WHEN heure23 = freqHeureMax THEN 23
        END AS heureMax,
        freqHeureMax

        FROM ReleveJournalier
        JOIN (
            SELECT leCompteur AS compt1, leJour AS jour1,
                -- Nombre de passage à l'heure qui a le plus de passage
                GREATEST(heure0, heure1, heure2, heure3, heure4, heure5, heure6, heure7, heure8, heure9, heure10, heure11, heure12, 
                    heure13, heure14, heure15, heure16, heure17, heure18, heure19, heure20, heure21, heure22, heure23) AS freqHeureMax
            FROM ReleveJournalier
        ) AS freqHeureMaxReleveJournalier ON leCompteur = compt1 AND leJour = jour1;

-- 1.2. Afficher pour chaque compteur le nombre total de passage, sa moyenne de passage par jour
--      sa fréquence d'erreur (le nombre ou la probabilité d'anomalie n'est pas nulle divisé par le nombre de jours relevés)
--      et son quartier (nom et numéro)

-- 1.2.1. Afficher pour chaque compteur le nombre total de passage et le nombre de jours relevés
CREATE OR REPLACE VIEW vue_statCompteurTotalPassage AS
    SELECT leCompteur, SUM(total) AS nombreTotalPassage, COUNT(*) AS nombreJourReleve
        FROM vue_ReleveJournalierResume
        GROUP BY leCompteur;

-- 1.2.2. Afficher pour chaque compteur le nombre d'erreurs
CREATE OR REPLACE VIEW vue_statCompteurNbErreurs AS
    SELECT leCompteur, COUNT(*) AS nbErreurs
        FROM ReleveJournalier
        WHERE probabiliteAnomalie IS NOT NULL
        GROUP BY leCompteur;

-- 1.2.3. Afficher pour chaque compteur l'heure de la journée qui est le plus souvent heure de pointe
CREATE OR REPLACE VIEW vue_statCompteurHeureMax AS
    SELECT leCompteur, COUNT(*) AS heureSouventFrequetee
        FROM (
            SELECT leCompteur, heureMax, COUNT(*) AS nbHeureMax
            FROM vue_ReleveJournalierResume
            GROUP BY leCompteur, heureMax
        ) AS CompteurHMaxCount
        GROUP BY leCompteur;

-- 1.2.4. Affichage final
CREATE OR REPLACE VIEW vue_statCompteur AS
    SELECT numero, libelle, direction, observations, longitude, latitude,
            code AS idQuartier, nom AS nomQuartier, nombreJourReleve, nombreTotalPassage,
            CAST(nombreTotalPassage / nombreJourReleve AS DECIMAL(6,2)) AS moyennePassageParJour,
            CAST(nbErreurs / nombreJourReleve AS DECIMAL(5,3)) AS frequenceErreurs,
            nbErreurs, heureSouventFrequetee
        FROM Compteur
        LEFT JOIN Quartier ON code = leQuartier
        LEFT JOIN vue_statCompteurTotalPassage AS T2 ON T2.leCompteur = numero
        LEFT JOIN vue_statCompteurNbErreurs AS T3 ON T3.leCompteur = numero
        LEFT JOIN vue_statCompteurHeureMax AS T4 ON T4.leCompteur = numero;

-- 2. Simplification des requêtes
-- 2.1. Afficher tous les présets
CREATE OR REPLACE VIEW vue_Presets AS
    SELECT idFavori, nomFavori
        FROM Favori
        JOIN Compte ON leCompte = idCompte
        WHERE typeDeCompte = 'Public';

-- 3. test des contraintes de la base de données
-- 3.1. Afficher les filtres qui n'ont pas un ordre valide (un ordre unique pour chaque filtre du même favori)
CREATE OR REPLACE VIEW vue_FiltreOrdreInvalide AS
    SELECT leFavori, idFiltre, ordre
        FROM Filtre
        WHERE leFavori IN (
            SELECT leFavori
            FROM Filtre
            GROUP BY leFavori, ordre
            HAVING COUNT(*) > 1
        );


