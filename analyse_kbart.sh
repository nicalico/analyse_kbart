#/bin/sh

OIFS="$IFS"
IFS=$'\n'

touch "./buffer"

kbart=$1
fichier_collections_a_exclure="./collections_a_exclure"
fichier_coverage_depth_a_inclure="./coverage_depth_a_inclure"
fichier_output="./output.sans.doublons.csv"
buffer="./buffer"

separateur=$(printf -- '-%.0s' {1..60})



############ Listes des inclusions et exclusions

declare -a collections_a_exclure

dos2unix -q $fichier_collections_a_exclure

for i in $(cat $fichier_collections_a_exclure | sed '/^[[:space:]]*$/d')
	do 
		collections_a_exclure+=("$i")
	done

cat $kbart | sed '/^[[:space:]]*$/d' > $fichier_output



############ Collections à exclure

lignes_kbart=$(wc -l < $fichier_output)

echo -e "\n\n"
echo $separateur
echo -e "Items dans le fichier: $((lignes_kbart-1))"

echo $separateur
echo -e "Application des exclusions (case insensitive) :"

for j in ${collections_a_exclure[@]}
	do 
		echo -e "  $j"
		awk -v collection_a_exclure="$j" 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if ($21 !~ collection_a_exclure) print $0}' $fichier_output > $buffer
		n_output=$(wc -l < $fichier_output)
		n_buffer=$(wc -l < $buffer)
		echo -e "    items exclus: $((n_output-n_buffer))"
		cat $buffer > $fichier_output
	done


# Formattage possible
#LC_NUMERIC=en_US printf "%'.f\n" $var

lignes_kbart_f=$(wc -l < $fichier_output)
echo -e "\nItems après exclusions: $((lignes_kbart_f-1))"



############ Coverage depth à inclure

echo $separateur
echo "Filtrage du champ coverage_depth"
echo "  Filtres appliqués: fulltext, ebook et video"

	# peut-on créer requête awk d'inclusion or en loopant sur un array plutôt que de hardcoder la requête?
	awk -v requete="$req" 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if ($14 ~ /coverage_depth/ || $14 ~ /fulltext/) print $0}' $fichier_output > $buffer
	n_output=$(wc -l < $fichier_output)
	n_buffer=$(wc -l < $buffer)
	echo -e "    items exclus: $((n_output-n_buffer))"
	cat $buffer > $fichier_output


cat $fichier_output > './output.avec.doublons.csv'


############ Statistiques

# Mettre ceci où on veut
echo $separateur
echo "Répartitions du champ coverage_depth"
awk -f stats.awk $fichier_output



############ Dédoublonnage

echo $separateur
echo -e "Dédoublonnages"

dedoublonnage()
	{
		awk -v champ=$1 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if (length($champ) == 0 || !visited[$champ]++) print $0}' $fichier_output > $buffer
		cat $buffer > $fichier_output
		lignes_kbart_f=$(wc -l < $fichier_output)
		echo -e "  Items après dédoublonnage: $((lignes_kbart_f-1))"
	}

echo -e "\nSur OCLC Number :"
	dedoublonnage '25'
	
echo -e "\nSur ISBN/ISSN imprimé :"
	dedoublonnage '2'
	
echo -e "\nSur ISBN/ISSN numérique :"
	dedoublonnage '3'

rm "./buffer"

IFS="$OIFS"	
