/*
 SAE Velos de nantes - Script de remplissage des tables non généré automaitquement
 Technologie : MySQL
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Matteo
 PITON Corentin
 PIERRE Noe
 */
--==================== Script de remplissage manuel ====================

INSERT INTO Calque VALUES
(1, 'Jours feriés'),
(2, 'Vacances Zone A'),
(3, 'Vacances Zone B'),
(4, 'Vacances Zone C'), 
(5, 'Weekends'),
(6, 'Confinements'),
(7, 'Températures');

INSERT INTO Compte (identifiant, motDePasse, typeDeCompte) VALUES
('Public', '$2y$10$5NuCCGhXT2W13ye2F61Y2uykz4cvgRrF/.3iEGrY3ufLD321gSRgK', 'Public'),
('testAdmin', '$2y$10$HODDcTSL.mhHoxqwK92rDegiVrn3Kwemf2xYGqjyqGQS6SdYr7BWq', 'Administrateur');