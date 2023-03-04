
def remplissageQuartier():
    # On ouvre le fichier qui détaille les quartiers de Nantes
    file1 = open("./data/data_quartiers_nantes.csv")
    content1 = file1.readlines() # Transforme le fichier en liste de lignes

    # On ouvre le fichier qui détaille la longueur des pistes cyclables
    file2 = open("./data/data_longueur_pistes_velo.csv")
    content2 = file2.readlines()  # Transforme le fichier en liste de lignes

    fileOutput = open("./Scripts/remplissageQuartier.sql", "w")

    # On parcours les deux fichiers
    for i in range(1, len(content1)):
        lineF1 = content1[i].replace("\n", "").split(";")
        code = lineF1[0]
        nom = lineF1[1]

        lineF2 = content2[i].replace("\n", "").split(";")
        longueurPiste = lineF2[1].replace(",", ".")

        # On écrit dans le fichier de sortie
        fileOutput.write("INSERT INTO Quartier (code, nom, longueurPiste) VALUES (" +
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
    content1 = file1.readlines() # Transforme le fichier en liste de lignes

    # On ouvre le fichier qui fait le lien entre un compteur et un quartier
    file2 = open("./data/data_quartier_compteur.csv")
    content2 = file2.readlines()  # Transforme le fichier en liste de lignes

    fileOutput = open("./Scripts/remplissageCompteur.sql", "w")

    # On parcours le premier fichier
    compteur = {}
    for i in range(1, len(content1)):
        lineF1 = content1[i].replace("\n", "").split(";")
        numero = lineF1[0]
        libelle = lineF1[1]
        observations = lineF1[2]
        geolocalisation = lineF1[3].split(",")
        longitude = geolocalisation[0]
        latitude = geolocalisation[1]

        if observations == "":
            observations = "NULL"
        else :
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

    # On écrit dans le fichier de sortie
    for numero in compteur:
        fileOutput.write("INSERT INTO Compteur (numero, libelle, observations, longitude, latitude, leQuartier) VALUES (" +
                         numero + ", '" + compteur[numero][0] + "'," + compteur[numero][1] + ", " + compteur[numero][2] + ", " + compteur[numero][3] + ", " + compteur[numero][4] + ");\n")

    # On ferme les fichiers
    file1.close()
    file2.close()
    fileOutput.close()


remplissageQuartier()
remplissageCompteur()