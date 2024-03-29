#/bin/sh

liste_inclusions_et_exclusions()
	{
	collections_a_exclure=()
	coverage_depth_a_inclure=()

	dos2unix -q $fichier_collections_a_exclure
	dos2unix -q $fichier_coverage_depth_a_inclure

	for i in $(cat $fichier_collections_a_exclure | sed '/^[[:space:]]*$/d')
		do 
			collections_a_exclure+=("$i")
		done

	for i in $(cat $fichier_coverage_depth_a_inclure | sed '/^[[:space:]]*$/d')
		do 
			coverage_depth_a_inclure+=("$i")
		done

	cat $kbart | sed '/^[[:space:]]*$/d' > $fichier_output

	lignes_kbart=$(wc -l < $fichier_output)

	echo -e "\n\n"
	echo $separateur
	printf "Items dans le fichier KBART: %'d \n" $((lignes_kbart-1))
	}

collections_a_exclure() 
	{
	echo $separateur
	echo -e "Filtrage des collections pérennes et en accès libre:"

	declare -i items_exclus
	items_exclus=0

	for j in ${collections_a_exclure[@]}
		do 
			awk -v collection_a_exclure="$j" 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if ($21 !~ collection_a_exclure && $22 !~ collection_a_exclure) print $0}' $fichier_output > $buffer
			n_output=$(wc -l < $fichier_output)
			n_buffer=$(wc -l < $buffer)
			printf "\t$j exclus: %'d \n" $((n_output-n_buffer))
			items_exclus+=$((n_output-n_buffer)) 
			cat $buffer > $fichier_output
		done

	# Formattage possible
	#LC_NUMERIC=en_US printf "%'.f\n" $var

	lignes_kbart_f=$(wc -l < $fichier_output)
	printf "Items retirés du fichier KBART: %'d" $items_exclus
	printf "\nItems conservés dans le fichier KBART: %'d \n" $((lignes_kbart_f-1))
	}

coverage_a_inclure() 
	{
	echo $separateur
	echo "Filtrage du champ coverage_depth"

	> $buffer
	head -1 $fichier_output >> $buffer
	n_buffer=1

	for k in ${coverage_depth_a_inclure[@]}
		do 
			awk -v coverage_depth="$k" 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if ($14 ~ coverage_depth) print $0}' $fichier_output >> $buffer
			n_output=$(wc -l < $buffer)
			printf "\t$k inclus: %'d \n" $((n_output-n_buffer))
			n_buffer=$(wc -l < $buffer)
		done

	printf "\nItems conservés dans le fichier KBART: %'d \n" $(($(wc -l < $buffer)-1))
		
	cat $buffer > $fichier_output

	cat $fichier_output > ./output/output.avec.doublons.csv
	}

dedoublonnage()
	{
		awk -v champ=$1 'BEGIN {FS="\t"; OFS=FS; IGNORECASE=1} {if (length($champ) == 0 || !visited[$champ]++) print $0}' $fichier_output > $buffer
		cat $buffer > $fichier_output
		lignes_kbart_f=$(wc -l < $fichier_output)
		printf "\tItems après dédoublonnage: %'d \n" $((lignes_kbart_f-1))
	}



if [ $# -eq 0 ]
	then 
		echo "Veuillez préciser le chemin du fichier à analyser. Ex. sh analyse_kbart.sh input/kbart_2021_06_08.txt"
		exit 1
fi

OIFS="$IFS"
IFS=$'\n'
LC_NUMERIC=en_CA

touch "./output/.buffer"

kbart=$1
fichier_collections_a_exclure="./collections_a_exclure"
fichier_coverage_depth_a_inclure="./coverage_depth_a_inclure"
fichier_output="./output/output.sans.doublons.csv"
buffer="./output/.buffer"

separateur=$(printf -- '-%.0s' {1..60})

liste_inclusions_et_exclusions

collections_a_exclure

coverage_a_inclure

echo $separateur
echo -e "Dédoublonnages"

echo -e "\nSur OCLC Number :"
	dedoublonnage '25'
	
echo -e "\nSur ISBN/ISSN imprimé :"
	dedoublonnage '2'
	
echo -e "\nSur ISBN/ISSN numérique :"
	dedoublonnage '3'

############ Statistiques

echo $separateur
echo "Répartition des valeurs dans le champ coverage_depth après traitement"
awk -f stats.awk $fichier_output

rm "./output/.buffer"

IFS="$OIFS"	
