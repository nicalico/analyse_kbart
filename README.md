## Analyse des fichiers KBART

### Environnement
- Le script peut-être utilisé avec un interpréteur shell, par exemple:
	- Cygwin sous Windows
	- Dans Linux (non testé)
	- Dans le terminal de MacIntosh (non testé)
- Le script doit être utilisé avec sudo, ou par un usager aillant les droits en écriture sur le répertoire. 
- Dans le cas de Cygwin, on s'assurera de démarrer le logiciel avec droits admin.

### Paramètrage
- Les mots-clés des collections à exclure peuvent être ajoutés dans le fichier exclusion, à raison d'une expression par ligne.
- Pour l'instant, les mots-clés pour filtrer le coverage_depth sont encore inscrits directement dans le code.

### Exécution
On invoque le script avec le nom du fichier kbart

sh analyse_kbart.sh chemin_et_nom_du_fichier_kbart.txt