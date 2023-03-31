/*
 SAE Velos de nantes - Script de remplissage des tables non généré automaitquement
 Technologie : MySQL
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Matéo
 PITON Corentin
 PIERRE Noe
 */
-- ==================== Script de remplissage manuel ====================

INSERT INTO Calque VALUES
(1, 'Jours feriés'),
(2, 'Vacances Zone A'),
(3, 'Vacances Zone B'),
(4, 'Vacances Zone C'), 
(5, 'Weekends'),
(6, 'Confinements'),
(7, 'Températures');

INSERT INTO Compte VALUES
(1, 'Public', '$2y$10$5NuCCGhXT2W13ye2F61Y2uykz4cvgRrF/.3iEGrY3ufLD321gSRgK', 'Public'),
(2, 'testAdmin', '$2y$10$HODDcTSL.mhHoxqwK92rDegiVrn3Kwemf2xYGqjyqGQS6SdYr7BWq', 'Administrateur');

-- ========= Remplissage de présets =========
-- Comparer l'année 2021 avec l'année 2022 sur l'ensemble des compteurs
INSERT INTO Favori (nomFavori, leCompte) VALUES
('Comparaison 2021/2022', 1);
INSERT INTO Filtre (typeCalcul, typeRegroupement, typeGraphique, ordre, dateDebut, dateFin, leFavori) VALUES
('Somme', 'Jour', 'Courbe', 1, '2021-01-01', '2022-01-01', 1),
('Somme', 'Jour', 'Courbe', 2, '2022-01-01', '2023-01-01', 1);
INSERT INTO FiltreCompteur VALUES 
(1,664), (2,664),
(1,665), (2,665),
(1,666), (2,666),
(1,667), (2,667),
(1,668), (2,668),
(1,669), (2,669),
(1,670), (2,670),
(1,672), (2,672),
(1,673), (2,673),
(1,674), (2,674),
(1,675), (2,675),
(1,676), (2,676),
(1,677), (2,677),
(1,679), (2,679),
(1,680), (2,680),
(1,681), (2,681),
(1,682), (2,682),
(1,683), (2,683),
(1,725), (2,725),
(1,727), (2,727),
(1,742), (2,742),
(1,743), (2,743),
(1,744), (2,744),
(1,745), (2,745),
(1,746), (2,746),
(1,747), (2,747),
(1,785), (2,785),
(1,786), (2,786),
(1,787), (2,787),
(1,788), (2,788),
(1,847), (2,847),
(1,880), (2,880),
(1,881), (2,881),
(1,890), (2,890),
(1,943), (2,943),
(1,944), (2,944),
(1,945), (2,945),
(1,946), (2,946),
(1,949), (2,949),
(1,950), (2,950),
(1,959), (2,959),
(1,960), (2,960),
(1,980), (2,980),
(1,981), (2,981),
(1,994), (2,994),
(1,995), (2,995),
(1,996), (2,996),
(1,997), (2,997),
(1,1041), (2,1041),
(1,1042), (2,1042);


