/*
 SAE Velos de nantes - Shema relationnel

 =============== Auteurs ===============
 GUERNY Baptiste
 PINTO DA SILVA Gabriel
 NOUVION Mattéo
 PITON Corentin
 PIERRE Noé

 ==================== Shema relationnel ====================
 
 Quartier(code(1), nom, longueurPiste)
 Compteur(numero(1), libelle, observations, longitude, latitude, @leQuartier = Quartier.code)
 Jour(jour(1), jourDeSemaine(NN), vacancesZoneB)
 ReleveJournalier(leCompteur=@Compteur.numero(1), leJour=@Jour.jour(1), heure0, heure1, ..., heure23, total, probabiliteAnomalie)

 -- Contraintes textuelles
    ReleveJournalier :
		- heureX >= 0
        - total >= 0
        - DOM(probabiliteAnomalie) = { 'Faible', 'Moyenne', 'Forte' }
	Quartier : 
		- longueurPiste >= 0
	Jour :
        - jour est de type DATE
		- 0 < jourDeSemaine <= 8
		- DOM(vacancesZoneB) = { 'Hors Vacances', 'Pont de l'Ascension', 'Vacances d'été', 'Vacances de la Toussaint', 'Vacances de Noël', 'Vacances de printemps', 'Vacances d'hiver' }
    Compteur:
        - longitude et latitude sont de type DECIMAL(18, 15)
        
*/