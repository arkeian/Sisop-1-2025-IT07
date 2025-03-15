1. a. awk -F, '$2 == "Chris Hemsworth" {count++} END {print "Chris Hemsworth membaca " count " buku."}' reading_data.csv

   b. awk -F, '$8 == "Tablet" {sum += $6; count++} 
END {if (count > 0) print "Rata-rata durasi membaca dengan Tablet adalah " sum/count " menit."}' reading_data.csv

   c. awk -F, 'NR==1 {next} {if ($7 > max) {max = $7; reader = $2; book = $3}} 
END {print "Pembaca dengan rating tertinggi:", reader, "-", book, "-", max}' reading_data.csv

   d. awk -F, '$9 == "Asia" && $5 > "2023-12-31" {genre_count[$4]++} END {max = 0; for (g in genre_count) if (genre_count[g] > max) 
{max = genre_count[g]; popular = g} print "Genre paling populer di Asia setelah 2023 adalah", popular, "dengan", max, "buku."}' reading_data.csv
