#!/bin/bash

id=0
today=$(date +%F)
LOG="logs/run_$today.log"
cities=("casa" "tanger" "agadir")
categories=("defective" "wrong_item" "changed_mind")

mkdir -p output archive logs


log() {
  echo "$1" | tee -a "$LOG"
}

log "[$(date +%H:%M)] INFO: job started"

# Nettoyage des fichiers temporaires .tmp
rm -f input/*.tmp

echo "id,date,city,reason,count" > output/report.csv
log "Fichier report.csv initialisé"


process_returns() {
    local city="$1"
    local file="input/returns_${city}.csv"

    # Nom de ville avec majuscule
    city_name="${city^}"

    # Parcourir les categories
    for reason in "${categories[@]}"; do

        count=$(grep -cF ",${reason}," "$file")

        ((id++))

        echo "$id,$today,$city_name,$reason,$count" >> output/report.csv

    done
    
    log "Traité : $city"
}


for city in "${cities[@]}"; do
    process_returns "$city"
done

cat output/report.csv


for city in "${cities[@]}"; do

    cp "input/returns_${city}.csv" "archive/returns_${city}_${today}.csv"

done


log "[$(date +%H:%M)] INFO: job finished"