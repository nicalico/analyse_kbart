## Analyse des fichiers KBART

### Environnement
- Le script peut-être utilisé avec un interpréteur shell, par exemple:
	- [Cygwin](https://www.cygwin.com/) sous Windows
	- Dans Linux (non testé)
	- Dans le terminal de Macintosh (non testé)
- Le script doit être utilisé avec sudo, ou par un usager aillant les droits en écriture sur le répertoire. Dans le cas de Cygwin, on s'assurera de démarrer le logiciel avec droits admin.

### Paramètrage
- Les mots-clés des collections à exclure peuvent être ajoutés dans le fichier `exclusion`, à raison d'une expression par ligne. Une expression peut contenir des espaces.
- Pour l'instant, les mots-clés pour filtrer le champ `coverage_depth` sont inscrits directement dans le code du ficher `analyse_kbart.sh`.

### Exécution
On invoque le script avec le nom du fichier kbart:

`sh analyse_kbart.sh chemin_et_nom_du_fichier_kbart.txt`