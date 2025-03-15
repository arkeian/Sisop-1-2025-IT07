#!/bin/bash

# Cek file CSV diberikan sebagai argumen
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <pokemon_usage.csv> --info OR $0 <pokemon_usage.csv> --grep <pokemon_name> OR $0 <file.csv> --filter <type>"
    exit 1
fi

FILE=$1
COMMAND=$2

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found!"
    exit 1
fi

# perintah --info
if [ "$COMMAND" == "--info" ]; then
    echo "Summary of $FILE"

    # Mencari Pokemon dengan Usage% tertinggi
    highest_usage=$(awk -F',' 'NR > 1 {if ($2 > max) {max=$2; name=$1}} END {print name, max}' "$FILE")

    # Mencari Pokemon dengan Raw Usage tertinggi
    highest_raw_usage=$(awk -F',' 'NR > 1 {if ($3 > max) {max=$3; name=$1}} END {print name, max}' "$FILE")

    # Cetak hasil dengan format kreatif
    echo "🔥 Highest Adjusted Usage: $(echo $highest_usage | awk '{print $1}') with $(echo $highest_usage | awk '{print $2}')%"
    echo "⚡ Highest Raw Usage:    $(echo $highest_raw_usage | awk '{print $1}') with $(echo $highest_raw_usage | awk '{print $2}') uses"

# perintah --grep, cari Pokemon berdasarkan nama
elif [ "$COMMAND" == "--grep" ]; then
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <pokemon_usage.csv> --grep <pokemon_name>"
        exit 1
    fi

    POKEMON_NAME=$3

    # Tampilkan header
    head -n 1 "$FILE"

    # Cari Pokémon dengan nama yang **tepat** dan tampilkan hasilnya
    awk -F',' -v name="$POKEMON_NAME" 'NR > 1 && tolower($1) == tolower(name)' "$FILE"

# Jika perintah adalah --filter, cari Pokemon berdasarkan Type
elif [ "$COMMAND" == "--filter" ]; then
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <pokemon_usage.csv> --filter <type>"
        exit 1
    fi

    TYPE=$3

    # Tampilkan header
    head -n 1 "$FILE"

    # Cari Pokémon yang memiliki Type1 atau Type2 sesuai input, lalu urutkan berdasarkan Usage%
    awk -F',' -v type="$TYPE" 'NR > 1 && (tolower($4) == tolower(type) || tolower($5) == tolower(type))' "$FILE" | sort -t',' -k2 -nr

else
    echo "Invalid command. Use '--info' to get summary, '--grep <pokemon>' to search, or '--filter <type>' to filter by type."
    exit 1
fi

