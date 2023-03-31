def header(title):
    entete = f"/*\n SAE Velos de nantes - {title}\n Technologie : MySQL\n \n =============== Auteurs ===============\n GUERNY Baptiste\n PINTO DA SILVA Gabriel\n NOUVION Matéo\n PITON Corentin\n PIERRE Noe\n*/ \n-- ==================== {title} ====================\n"
    return entete

def remplissageQuartier():
    # On ouvre le fichier qui détaille les quartiers de Nantes
    file1 = open("./data/data_quartiers_nantes.csv")

    content1 = file1.readlines()  # Transforme le fichier en liste de lignes

    # On ouvre le fichier qui détaille la longueur des pistes cyclables
    file2 = open("./data/data_longueur_pistes_velo.csv")
    content2 = file2.readlines()  # Transforme le fichier en liste de lignes

    fileOutput = open("./Scripts/Base V1/remplissageQuartier.sql", "w")
    fileOutput.write(header("Script de remplissage de la table Quartier"))

    # On parcours les deux fichiers
    for i in range(1, len(content1)):
        lineF1 = content1[i].replace("\n", "").split(";")
        code = lineF1[0]
        nom = lineF1[1]

        lineF2 = content2[i].replace("\n", "").split(";")
        longueurPiste = lineF2[1].replace(",", ".")

        # On écrit dans le fichier de sortie
        fileOutput.write("INSERT INTO Quartier VALUES (" +
                         code + ", '" + nom + "', " + longueurPiste + ");\n")

    # On ferme les fichiers
    file1.close()
    file2.close()
    fileOutput.close()

# Les données sont dans le fichier data_geolocalisationCompteur.csv et dans data_quartier_compteur.csv
# La table Compteur est de la forme :  numero, libelle, observations, longitude, latitude, leQuartier
# Les 2 fichiers ne sont pas dans le même ordre, il faut donc les parcourir l'un après l'autre

# Donc il faut parcourrir le premier fichier et on ajoute tous les compteurs dans un dictionnaire de la forme : {numero : [libelle, observations, longitude, latitude, NULL],...} Si observations est une chaine vide on met NULL
# Ensuite, on parcours le deuxième fichier et on complète le dictionnaire avec le code du quartier, si le compteur n'est pas dans le dictionnaire on l'ajoute dans le dictionnaire sous cette forme : {numero : [NULL, NULL, NULL, NULL, leQuartier]}


def remplissageCompteur():
    # On ouvre le fichier qui détaille les compteurs de Nantes
    file1 = open("./data/data_geolocalisationCompteur.csv")
    content1 = file1.readlines()  # Transforme le fichier en liste de lignes

    # On ouvre le fichier qui fait le lien entre un compteur et un quartier
    file2 = open("./data/data_quartier_compteur.csv")
    content2 = file2.readlines()  # Transforme le fichier en liste de lignes

    # on ouvre le fichier qui contiens les données des capteurs
    file3 = open("./data/data_comptageVelo_nettoye.csv")
    content3 = file3.readlines()  # Transforme le fichier en liste de lignes

    fileOutput = open("./Scripts/Base V1/remplissageCompteur.sql", "w")
    fileOutput.write(header("Script de remplissage de la table Compteur"))


    # On parcours le premier fichier
    compteur = {}
    for i in range(1, len(content1)):
        lineF1 = content1[i].replace("\n", "").split(";")
        numero = lineF1[0]
        libelle = "'" + lineF1[1] + "'"
        observations = lineF1[2]
        geolocalisation = lineF1[3].split(",")
        longitude = geolocalisation[0]
        latitude = geolocalisation[1]

        if observations == "":
            observations = "NULL"
        else:
            observations = "'" + observations + "'"

        compteur[numero] = [libelle, observations, longitude, latitude, "NULL"]

    # On parcours le deuxième fichier
    for i in range(1, len(content2)):
        lineF2 = content2[i].replace("\n", "").split(";")
        numero = lineF2[0]
        if lineF2[1] == "":
            leQuartier = "NULL"
        else:
            leQuartier = lineF2[1]

        if numero in compteur:
            compteur[numero][4] = leQuartier
        else:
            compteur[numero] = ["NULL", "NULL", "NULL", "NULL", leQuartier]

    # On parcours le troisième fichier
    for i in range(1, len(content3)):
        lineF3 = content3[i].replace("\n", "").split(";")
        numero = lineF3[0].lstrip('0')
        if numero not in compteur:
            compteur[numero] = ["NULL", "NULL", "NULL", "NULL", "NULL"]

    # On écrit dans le fichier de sortie
    for numero in compteur:
        fileOutput.write("INSERT INTO Compteur VALUES (" +
                         numero + ", " + compteur[numero][0] + "," + compteur[numero][1] + ", " + compteur[numero][2] + ", " + compteur[numero][3] + ", " + compteur[numero][4] + ");\n")

    # On ferme les fichiers
    file1.close()
    file2.close()
    file3.close()
    fileOutput.close()

# Pour remplir la table Jour et la table ReleveJournalier il faut parcourir le fichier data_comptageVelo_nettoye.csv qui détaille les relevés journaliers
# Table Jour : datejour, jourDeSemaine, vacancesZoneB
# Table ReleveJournalier : leCompteur, leJour, heure0, heure1, heure2, heure3, heure4, heure5, heure6, heure7, heure8, heure9, heure10, heure11, heure12, heure13, heure14, heure15, heure16, heure17, heure18, heure19, heure20, heure21, heure22, heure23, total, probabiliteAnomalie
# On parcours le fichier, on créé direct le fichier remplissageRelerJournalier.sql et on ajoute les jours dans un dictionnaire de la forme : {date : ,...} Si la date est déjà dans le dictionnaire on ne l'ajoute pas


def remplissageReleveJournalier_Jour():
    # On ouvre le fichier qui détaille les relevés journaliers des compteurs de Nantes
    file1 = open("./data/data_comptageVelo_nettoye.csv")
    content1 = file1.readlines()  # Transforme le fichier en liste de lignes

    file2 = open("./data/data_temperature.csv")
    temperatures = file2.readlines()
    file2.close()

    fileOutputReleveJournalier = open(
        "./Scripts/Base V1/remplissageReleveJournalier.sql", "w")
    fileOutputReleveJournalier.write(
        header("Script de remplissage de la table ReleveJournalier"))
    fileOutputReleveJournalier.write("INSERT INTO ReleveJournalier VALUES\n")

    fileOutputJour = open("./Scripts/Base V1/remplissageJour.sql", "w")
    fileOutputJour.write(header("Script de remplissage de la table Jour"))

    chaineComplete = ""
    # On parcours le fichier
    jour = {}
    for i in range(1, len(content1)):
        lineF1 = content1[i].replace("\n", "").split(";")
        if lineF1[28] != "Forte" and lineF1[1] != "":
            numero = lineF1[0]
            # libelle = ligneF1[1]
            date = lineF1[2]
            heures = {}
            for j in range(3, 27):
                if lineF1[j] == "" or int(lineF1[j]) < 0:
                    heures[j-3] = "0"
                else:
                    heures[j-3] = lineF1[j]

            total = lineF1[27]
            if int(total) < 0:
                total = "0"

            if lineF1[28] == "":
                probabiliteAnomalie = "NULL"
            else:
                probabiliteAnomalie = "'" + lineF1[28] + "'"

            # On genere la ligne
            ligneOutput = "(" + numero + ",DATE '" + date + "',"
            for heure in heures:
                ligneOutput += heures[heure] + ","
            ligneOutput += total + "," + probabiliteAnomalie + "),\n"

            # On ajoute a la chaine complete la ligne en cour
            chaineComplete += ligneOutput

            # On ajoute le jour dans le dictionnaire
            if date not in jour:
                jourDeSemaine = lineF1[29]
                # On remplace les ' par des '' pour éviter les erreurs SQL
                vacancesZoneB = lineF1[32].replace("'", "''")
                jour[date] = [jourDeSemaine, vacancesZoneB]

    # On ajoute les températures
    for tempJour in temperatures[1:]:
        tempJour = tempJour.replace("\n", "").replace(",", ".").split(";")
        jour[tempJour[0]].append(tempJour[1])

    # On écrit dans le fichier de sortie de la table ReleveJournalier
    chaineComplete = chaineComplete[:-2] + ";"
    fileOutputReleveJournalier.write(chaineComplete)

    # On écrit dans le fichier de sortie de la table Jour
    for date in jour:
        if len(jour[date]) == 2:
            jour[date].append("NULL")
        fileOutputJour.write("INSERT INTO Jour VALUES (DATE '" +
                             date + "', " + jour[date][0] + ", '" + jour[date][1] + "', " + jour[date][2] + ");\n")


remplissageQuartier()
remplissageCompteur()
remplissageReleveJournalier_Jour()
