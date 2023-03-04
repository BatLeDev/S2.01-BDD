
def remplissageQuartier():
    # On ouvre le fichier qui détaille les quartiers de Nantes
    file1 = open("./data/data_quartiers_nantes.csv")
    content1 = file1.readlines() # Transforme le fichier en liste de lignes

    # On ouvre le fichier qui détaille la longueur des pistes cyclables
    file2 = open("./data/data_longueur_pistes_velo.csv")
    content2 = file2.readlines()  # Transforme le fichier en liste de lignes

    fileOutput = open("./ScriptsSQL/remplissageQuartier.sql", "w")

    # On parcours les deux fichiers
    for i in range(1, len(content1)):
        lineF1 = content1[i].replace("\n", "").split(";")
        code = lineF1[0]
        nom = lineF1[1]

        lineF2 = content2[i].replace("\n", "").split(";")
        longueurPiste = lineF2[1]

        # On écrit dans le fichier de sortie
        fileOutput.write("INSERT INTO Quartier VALUES ({}, '{}', {});\n".format(code, nom, longueurPiste))

    # On ferme les fichiers
    file1.close()
    file2.close()
    fileOutput.close()

remplissageQuartier()

