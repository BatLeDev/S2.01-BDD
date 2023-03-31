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
 
 ==================== Shema relationnel V2 ( Trié par ordre de création )====================
 
 Quartier(code(1), nom, longueurPiste)
 Compteur(numero(1), libelle, destination, observations, longitude, latitude, @leQuartier = Quartier.code)
 Jour(jourDate(1), jourDeSemaine, temperature)
 ReleveJournalier(leCompteur=@Compteur.numero(1), leJour=@Jour.jourDate(1), heure0, heure1, ..., heure23, probabiliteAnomalie)
 Compte(idCompte (1), identifiant (NN)(UQ), motDePasse (NN), typeDeCompte)
 Favori(idFavori(1), nomFavori, @leCompte = Compte.idCompte)
 Calque(idCalque(1), nomCalque)
 Filtre(idFiltre(1), typeCalcul(NN), typeRegroupement(NN), typeGraphique(NN), ordre(NN), dateDebut(NN), dateFin, @leFavori = Favori.idFavori)
 FiltreCompteur(leFiltre = Filtre.idFiltre(1), @leCompteur = Compteur.numero(1))
 CalqueJour(leCalque = Calque.idCalque(1), @leJour = Jour.jourDate(1))
 CalqueFavori(leCalque = Calque.idCalque(1), @leFavori = Favori.idFavori(1))
 
 
 -- Contraintes textuelles
 Table Quartier
 - longueurPiste >= 0
 
 Table Jour
 - 0 < jourDeSemaine < 8
 
 Table ReleveJournalier
 - somme est dérivable à partir de la somme des heures
 - heureMax est dérivable, elle représente l’heure où il y a eu le plus de passage
 - freqHeureMax représente la fréquentation de l’heure max
 - 0 <= heureMax <24
 - heureX >= 0 
 - DOM(probabiliteAnomalie) = { 'Faible', 'Moyenne', 'Forte' }
 
 Table Compte
 - idCompte est auto-incrémenté
 - DOM(typeDeCompte) = { 'Public', 'Utilisateur', 'Elu', ‘Administrateur' }
 
 Table Favori
 - idFavori est auto incrémenté
 
 Table Calque
 - idCalque est auto incrémenté
 
 Table Filtre
 - idFiltre est auto incrémenté
 - DOM(typeCalcul) = { 'Somme', 'Moyenne', 'Somme des sommes', 'Moyenne des sommes' }
 - DOM(typeRegroupement) = { 'Heure', 'Jour', 'Semaine', 'Mois', 'Annee' }
 - DOM(typeGraphique) = { 'Courbe', 'Histogramme' }
 - 0 < ordre < 6
 - ordre est unique pour un favori
 - dateDebut <= dateFin
 
 Un filtre est associé à au moins un compteur
 
 */