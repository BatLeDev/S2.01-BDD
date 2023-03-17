/*
 SAE Velos de nantes - Shema relationnel V2
 ==================== Description ===================
 Shema relationnel de la base de donnée avec les améliorations de la question 4.
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Mattéo
 PITON Corentin
 PIERRE Noé
 
 ==================== Shema relationnel V2====================
 
 Quartier(code(1), nom, longueurPiste)
 Compteur(numero(1), libelle, observations, longitude, latitude, @leQuartier = Quartier.code)
 Jour(jourDate(1), jourDeSemaine, vacancesZoneB)
 ReleveJournalier(leCompteur=@Compteur.numero(1), leJour=@Jour.jourDate(1), heure0, heure1, ..., heure23, total, probabiliteAnomalie)
 
 -- Contraintes textuelles

 
 */