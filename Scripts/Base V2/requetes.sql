/*
 SAE Velos de nantes - Script comportant les requêtes SQL demandées
 Technologie : MySQL 
 (Les requêtes séparées par des == sont écrites en Oracle SQL pour respecté la consigne, mais écrit également en MySQL)
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Matteo
 PITON Corentin
 PIERRE Noe
 */
--==================== Script comportant les requêtes SQL demandées ====================

-- 1. projection avec restriction 
-- 1) Quels sont les noms des quartiers où il y a plus de 30km de piste ?
SELECT DISTINCT(nom)
    FROM Quartier
    WHERE longueurPiste >= 30000;

-- 2) Quels sont les dates de tous les dimanches (toute année confondu) ?
SELECT jourDate
    FROM Jour
    WHERE jourDeSemaine = 7;


-- 2. union
-- 3) Quels jours sont les dimanches et les jours où il y a eu une probabilité d'erreur Faible sur un relevé?
SELECT jourDate
    FROM Jour
    WHERE jourDeSemaine IN (7) 
UNION
SELECT leJour
    FROM ReleveJournalier
    WHERE probabiliteAnomalie = 'Faible';


-- ==================================================================
-- 3.difference ensembliste
-- 4) Quels sont les jours où il n'y eu aucun passage à 8h sur un capteur avec une probabilité d'anomalie faible, 
--    mais qui ne sont pas des week-end ?

/* Requete Oracle SQL
 SELECT DISTINCT(leJour)
     FROM ReleveJournalier
     WHERE total = 0
     AND probabiliteAnomalie = 'Faible'
 MINUS
 SELECT jourDate
     FROM Jour
     WHERE jourDeSemaine IN (6,7);
*/

SELECT DISTINCT(leJour)
    FROM ReleveJournalier
    WHERE heure8 = 0
    AND probabiliteAnomalie = 'Faible'
    AND leJour NOT IN (
        SELECT jourDate
            FROM Jour
            WHERE jourDeSemaine IN (6,7)
    );
-- ==================================================================


-- 4.jointure interne
-- 5) Quels sont les compteurs du quartier 'Doulon - Bottière' ayant un relevé manuel 
SELECT numero
    FROM Compteur
    JOIN Quartier ON leQuartier = code
    WHERE nom = 'Doulon - Bottière'
    AND observations ='Releve manuel';

-- 6) Quel est le nombre de passage maximum à 8h sur un compteur du centre ville ?
SELECT MAX(heure8)
    FROM ReleveJournalier
    JOIN Compteur ON leCompteur = numero
    JOIN Quartier ON leQuartier = code
    WHERE nom = 'Centre Ville';


-- ==================================================================
-- 5.tri + limitation (ROWNUM)
-- 7) Quels sont les 10 premiers jours les plus fréquentés à 12h, 
--    afficher le numero du capteur, le jour du relevé et le nombre de passage ?

/* Requete Oracle SQL
 SELECT *
     FROM (
         SELECT leCompteur, leJour, heure12
             FROM ReleveJournalier
             ORDER BY heure12 DESC
     )
     WHERE ROWNUM <= 10;
*/

SELECT leCompteur, leJour, heure12
    FROM ReleveJournalier
    ORDER BY heure12 DESC
    LIMIT 10;
-- ==================================================================


-- 6.jointure externe
-- 8) Quels sont les noms de quartier (peut être null) de chaque compteur ?
SELECT numero, nom
    FROM Compteur 
    LEFT JOIN Quartier ON leQuartier = code;

-- 9) Quels est la liste des presets des présets (Favoris du compte de type 'Public') ?
SELECT idFavori, nomFavori
    FROM Compte
    LEFT JOIN Favori ON leCompte = idCompte
    WHERE typeDeCompte = 'Public';


-- 7.fonction de groupe sans regroupement
-- 10) Quel est le nombre de week-end enregistrés ?
SELECT CAST(count(*) / 2 AS INT) AS nbWeekEnds    
    FROM Jour
    WHERE jourDeSemaine IN (6,7);
/*
 Le nombre de week-end est égal au nombre de samedi et dimanche divisé par 2
 Cast est utilisé pour arrondir le nombre de week-end à l'entier le plus proche
 On renomme la colonne pour que son nom soit plus explicite
*/

-- 11) Quel est le nombre moyen de passage à midi pour le mois d'aout 2022 où la probabilité d'anomalie n'est pas définie ?
SELECT AVG(heure12) AS moyPassageMidi
    FROM ReleveJournalier
    WHERE probabiliteAnomalie IS NULL
    AND leJour >= "2022-08-01" 
    AND leJour < "2022-09-01";


-- 8.regroupement avec fonction de groupe
-- 12) Pour chaque compteur, combien de relevé journalier sans anomalie a-t-il (Il peut en avoir 0) ?
SELECT numero, COUNT(leCompteur) AS nbReleves
    FROM Compteur
    LEFT JOIN ReleveJournalier ON leCompteur = numero
    WHERE probabiliteAnomalie IS NULL
    GROUP BY numero;

-- 13) Quel est le nombre de Compteur par Quartier (Il peut en avoir 0) ?
SELECT nom, COUNT(leQuartier) AS nbCompteurs
    FROM Quartier
    LEFT JOIN Compteur ON leQuartier = code
    GROUP BY nom
    ORDER BY nbCompteurs DESC;


-- ==================================================================
-- 9. regroupement et restriction (avec HAVING)
-- 14) Quels sont les numéros des Compteurs ayant plus de 10 relevés journaliers avec anomalie ?
SELECT leCompteur, COUNT(*) AS nbReleves
    FROM ReleveJournalier
    WHERE probabiliteAnomalie IS NOT NULL
    GROUP BY leCompteur
    HAVING COUNT(*) > 10;

-- 15) Quels sont les numéros des Quartier ayant le plus de compteurs ?
/* Requete Oracle SQL
 SELECT leQuartier
     FROM Compteur
     GROUP BY leQuartier
     HAVING COUNT(*) >= (
         SELECT MAX(COUNT(*))
             FROM Compteur
             GROUP BY leQuartier
     );
*/

SELECT leQuartier, COUNT(*) AS nbCompteurs
    FROM Compteur
    GROUP BY leQuartier
    HAVING COUNT(*) >= (
        SELECT COUNT(*) AS nbCompteurs
            FROM Compteur
            GROUP BY leQuartier
            ORDER BY nbCompteurs DESC
            LIMIT 1
    );
-- ==================================================================


-- 10.Division
-- 16) Quels sont les compteurs qui ont un relevé pour chaque jour enregistré ?
SELECT leCompteur
    FROM ReleveJournalier
    GROUP BY leCompteur
    HAVING(COUNT(*)) = (
        SELECT COUNT(*)
            FROM Jour
    );


-- 11.test des valeurs (avec IN ou NOT IN)
-- 17) Quels sont les compteurs qui n'ont pas de relevé pour le 1er janvier 2022 ?
SELECT numero
    FROM Compteur
    WHERE numero NOT IN (
        SELECT leCompteur
            FROM ReleveJournalier
            WHERE leJour = "2022-01-01"
    );


-- 12 test d’existence (avec EXISTS ou NOT EXISTS)
-- 18) Quels sont les jours feriés qui tombent pendant un week-end ?
SELECT jourDate
    FROM Jour
    WHERE jourDeSemaine IN (6,7)
    AND EXISTS (
        SELECT *
            FROM CalqueJour
            WHERE leJour = jourDate
            AND leCalque = (
                SELECT idCalque
                    FROM Calque
                    WHERE nomCalque = 'Jours feriés'
            )
    );
