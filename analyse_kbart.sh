#/bin/sh

OIFS="$IFS"
IFS=$'\n'

touch "./buffer"

kbart=$1
liste_exclusions="./exclusions"
output="./output.csv"
buffer="./buffer"

separateur=$(printf -- '-%.0s' {1..60})



############ Listes des inclusions et exclusions

declare -a exclusions

dos2unix -q $liste_exclusions

for i in $(cat $liste_exclusions | sed '/^[[:space:]]*$/d')
	do 
		exclusions+=("$i")
	done

cat $kbart | sed '/^[[:space:]]*$/d' > $output



############ Collections à exclure

lignes_kbart=$(wc -l < $output)

echo -e "\n\n"
echo $separateur
echo -e "Items dans le fichier: $((lignes_kbart-1))"

echo $separateur
echo -e "Application des exclusions (case insensitive) :"

for j in ${exclusions[@]}
	do 
		echo -e "  $j"
		awk -v exclusions="$j" 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if ($21 !~ exclusions) print $0}' $output > $buffer
		n_output=$(wc -l < $output)
		n_buffer=$(wc -l < $buffer)
		echo -e "    items exclus: $((n_output-n_buffer))"
		cat $buffer > $output
	done

cat $output > './output.apres.exclusions.csv'

# Formattage possible
#LC_NUMERIC=en_US printf "%'.f\n" $var

lignes_kbart_f=$(wc -l < $output)
echo -e "\nItems après exclusions: $((lignes_kbart_f-1))"



############ Coverage depth à inclure

echo $separateur
echo "Filtrage du champ coverage_depth"
echo "  Filtres appliqués: fulltext, ebook et video"

	# peut-on créer requête awk d'inclusion or en loopant sur un array plutôt que de hardcoder la requête?
	awk -v requete="$req" 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if ($14 ~ /fulltext/ || $14 ~ /ebook/ || $14 ~ /video/) print $0}' $output > $buffer
	n_output=$(wc -l < $output)
	n_buffer=$(wc -l < $buffer)
	echo -e "    items exclus: $((n_output-n_buffer))"
	cat $buffer > $output



############ Statistiques

# Mettre ceci où on veut
echo $separateur
echo "Répartitions du champ coverage_depth"
awk -f stats.awk $output



############ Dédoublonnage

echo $separateur
echo -e "Dédoublonnages"

dedoublonnage()
	{
		awk -v champ=$1 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if (length($champ) == 0 || !visited[$champ]++) print $0}' $output > $buffer
		cat $buffer > $output
		lignes_kbart_f=$(wc -l < $output)
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
