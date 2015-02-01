# Generates translation templates for other languages from the specified file.
import os, shutil

# Settings
modName = "Extended UI"
languageIndex = 1
targetDirectory = os.path.join(os.getcwd(), "Data", "Interface", "Translations", "")

# Script
languages = ["CZECH", "ENGLISH", "FRENCH", "GERMAN", "ITALIAN", "JAPANESE", "POLISH", "RUSSIAN", "SPANISH"]
fileName = modName + "_" + languages[languageIndex] + ".txt"
if os.path.isfile(targetDirectory + fileName):
	if (modName != "") and (languageIndex >= 0):
		i = 0
		while i < len(languages):
			if i != languageIndex:
				shutil.copy((targetDirectory + fileName), (targetDirectory + modName + "_" + languages[i] + ".txt"))
			i += 1
else:
	print("\'" + fileName + "\' does not exist in \'" + targetDirectory + "\'")