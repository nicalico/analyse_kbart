## Analyse des fichiers KBART

### Environnement
- Le script peut-être utilisé avec un interpréteur shell, par exemple:
	- [Cygwin](https://www.cygwin.com/) sous Windows
	- Dans Linux (non testé)
	- Dans le terminal de Macintosh (non testé)
- Le script doit être utilisé avec sudo, ou par un usager aillant les droits en écriture sur le répertoire. Dans le cas de Cygwin, on s'assurera de démarrer le logiciel avec droits admin.

### Paramètrage
- Les collections à exclure peuvent être spécifiées dans le fichier `collections_a_exclure`, à raison d'une expression par ligne. 
- Les collections à exclure sont utilisées pour filtrer sur les champs oclc_collection_id et oclc_collection_name ; on peut donc indiquer des mots clés ou des identifiants de collection.
- Le champ `coverage_depth` peut être filtré grâce au fichier `coverage_depth_a_inclure`, à raison d'une expression par ligne
- Une expression peut contenir des espaces, mais on évitera de laisser des espaces avant ou après l'expression.

### Exécution
On invoque le script avec le nom du fichier kbart:

`sh analyse_kbart.sh input/fichier_kbart.txt`
