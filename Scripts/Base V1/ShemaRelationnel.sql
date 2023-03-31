/*
 SAE Velos de nantes - Shema relationnel
 
 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Matéo
 PITON Corentin
 PIERRE Noé
 
 ==================== Shema relationnel ====================
 
 Quartier(code(1), nom, longueurPiste)
 Compteur(numero(1), libelle, observations, longitude, latitude, @leQuartier = Quartier.code)
 Jour(jourDate(1), jourDeSemaine, vacancesZoneB, temperature)
 ReleveJournalier(leCompteur=@Compteur.numero(1), leJour=@Jour.jourDate(1), heure0, heure1, ..., heure23, total, probabiliteAnomalie)
 
 -- Contraintes textuelles
 ReleveJournalier :
 - heureX >= 0
 - total >= 0
 - DOM(probabiliteAnomalie) = { 'Faible', 'Moyenne', 'Forte' }

 Quartier :
 - longueurPiste >= 0

 Jour :
 - jourDate est de type DATE
 - 0 < jourDeSemaine < 8
 - DOM(vacancesZoneB) = { 'Hors Vacances', 'Pont de l'Ascension', 'Vacances d'été', 'Vacances de la Toussaint', 'Vacances de Noël', 'Vacances de printemps', 'Vacances d'hiver' }
 - temperature est de type DECIMAL(5, 2)

 Compteur:
 - longitude et latitude sont de type DECIMAL(20,18)

 numero, code, jourDeSemaine, total et les heures sont de type entier.
 Tous les autres champs sont de type chaines de caractères.
 
 */