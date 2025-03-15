#!/bin/bash

clear

filename=$1
shift

info() {
    maxadj=0
    maxraw=0
    {
        read header
        while IFS="," read pokemon adjusage rawusage _
        do
            floatadj=${adjusage%"%"}
            if (( $(echo "$floatadj > $maxadj" |bc -l) ))
            then
                maxadj=$floatadj
                pokemon1=$pokemon
            fi
            if [ $rawusage -gt $maxraw ]
            then
                maxraw=$rawusage
                pokemon2=$pokemon
            fi
        done
    } < $filename
    printf "Highest Usage by Winrate: %s with %s%%\nHighest Raw Usage: %s with %s appearance\n" "$pokemon1" $maxadj "$pokemon2" $maxraw
}

sortalpha() {
    {
        read header
        printf "%s\n" $header
        case "$1" in
            usage)
                sort -t "," -k2 -n -r
                ;;
            rawusage)
                sort -t "," -k3 -n -r
                ;;
            name)
                sort -t "," -k1 -r
                ;;
            hp)
                sort -t "," -k6 -n -r
                ;;
            atk)
                sort -t "," -k7 -n -r
                ;;
            def)
                sort -t "," -k8 -n -r
                ;;
            spatk)
                sort -t "," -k9 -n -r
                ;;
            spdef)
                sort -t "," -k10 -n -r
                ;;
            speed)
                sort -t "," -k11 -n -r
                ;;
        esac
    } <$filename
}

grep() {
    head -n 1 "$filename"

    awk -F',' -v name="$1" 'NR > 1 && tolower($1) == tolower(name)' "$filename"
}

filter() {
    head -n 1 "$filename"

    awk -F',' -v type="$1" 'NR > 1 && (tolower($4) == tolower(type) || tolower($5) == tolower(type))' "$filename" | sort -t',' -k2 -nr
}

while [ "$#" -gt 0 ]
do
    case "$1" in
        --info)
            info
            ;;
        --sort)
            shift
            sortby=$1
            sortalpha $sortby
            ;;
        --grep)
            if [ "$#" -ne 2 ]; then
                echo "Usage: $0 <pokemon_usage.csv> --grep <pokemon_name>"
                exit 1
            fi
            shift
            pokemon=$1
            grep $pokemon
            ;;
        --filter)
            if [ "$#" -ne 2 ]; then
                echo "Usage: $0 <pokemon_usage.csv> --filter <type>"
                exit 1
            fi
            shift
            type=$1
            filter $type
            ;;
        *)
            printf "Unknown Argument\n" >&2
    esac
    shift
done
