# Laporan Resmi Modul 1 Kelompok IT-07
## Anggota

| Nama 				| NRP		|
|-------------------------------|---------------|
| Muhammad Rakha Hananditya R.	| 5027241015 	|
| Zaenal Mustofa		| 5027241018 	|
| Mochkamad Maulana Syafaat	| 5027241021 	|

## Table Of Content
1. Poppo Siroyo
   1. Buku Chris Hemsworth
   2. Rata-rata Durasi Membaca
   3. Rating Tertinggi
   4. Genre Paling Populer di Asia
2. Observer: Penjaga Fragmen Realitas
   1. First Step in a New World
   2. Radiant Genesis
   3. Unceasing Spirit
   4. The Eternal Realm of Light
   5. The Brutality of Glass
   6. In Grief and Great Delight
   7. On Fate's Approach
   8. The Disfigured Flow of Time
   9. Irruption of New Color
3. The Dark Side of the Moon
   1. Speak to Me
   2. On the Run
   3. Time
   4. Money
   5. Brain Damage
4. Pokemon “Generation 9 OverUsed 6v6 Singles
   1. Melihat summary dari data
   2. Mengurutkan Pokemon berdasarkan data kolom
   3. Mencari nama Pokemon tertentu
   4. Mencari Pokemon berdasarkan filter nama type
   5. Error handling
   6. Help screen yang menarik

## Soal 1

a. Poppo bisa menggunakan AWK atau grep untuk menghitung jumlah baris dalam file reading_data.csv yang menunjukkan buku-buku yang dibaca oleh Chris Hemsworth.

	awk -F, '$2 == "Chris Hemsworth" {count++} END {print "Chris Hemsworth membaca " count " buku."}' reading_data.csv

b. Siroyo bisa menggunakan AWK untuk menghitung rata-rata durasi membaca (Reading_Duration_Minutes) untuk buku-buku yang dibaca menggunakan "Tablet" dari file reading_data.csv

	awk -F, '$8 == "Tablet" {sum += $6; count++} END {if (count > 0) print "Rata-rata durasi membaca dengan Tablet adalah " sum/count " menit."}' reading_data.csv

c. Poppo bisa menggunakan AWK untuk mencari siapa yang memberikan rating tertinggi beserta nama pembaca dan judul buku dari file reading_data.csv

	awk -F, 'NR==1 {next} {if ($7 > max) {max = $7; reader = $2; book = $3}} END {print "Pembaca dengan rating tertinggi:", reader, "-", book, "-", max}' reading_data.csv

 d. Siroyo bisa menggunakan AWK untuk menemukan genre yang paling populer di Asia setelah 31 Desember 2023 berdasarkan data di reading_data.csv.

 	awk -F, '$9 == "Asia" && $5 > "2023-12-31" {genre_count[$4]++} END {max = 0; for (g in genre_count) if (genre_count[g] > max) {max = genre_count[g]; popular = g} print "Genre paling populer di Asia setelah 2023 adalah", popular, "dengan", max, "buku."}' reading_data.csv


## Soal 2

a. pertama membuat dua shell script, login.sh dan register.sh, yang dimana database “Player” disimpan di /data/player.csv. Untuk register, parameter yang dipakai yaitu email, username, dan password. Untuk login, parameter yang dipakai yaitu email dan password.

login.sh

```sh# Sisop-1-2025-IT07
#!/bin/bash

DB_FILE="/home/maulana/data/player.csv"
SALT="arcae_salt"

read -p "Masukkan email: " email
read -p "Masukkan password: " password

if ! grep -q "^$email," "$DB_FILE"; then
    echo " Email tidak ditemukan"
    exit 1
fi
ambil_hash=$(grep "^$email," "$DB_FILE" | cut -d',' -f3)
hash_password=$(echo -n "$password$SALT" | sha256sum | awk '{print $1}')
if [ "$hash_password" = "$ambil_hash" ]; then
    echo "Selamat datang, $(grep "^$email," "$DB_FILE" | cut -d',' -f2)"
else
    echo " Password salah "
    exit 1
fi
```
![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-19_21_57_54.png?raw=true)


register.sh

```sh
#!/bin/bash 

DB_FILE="/home/maulana/data/player.csv"
SALT="arcae_salt"

read -p "Masukkan email: " email
read -p "Masukkan username: " username
read -p "Masukkan password: " password

if [[ "$email" != *@*.* ]]; then
    echo "Email tidak valid"
    exit 1
fi

if [[ ! "$password" =~ [A-Z] || ! "$password" =~ [a-z] || ! "$password" =~ [0-9] || ${#password} -lt 8 ]]; then
    echo "Password harus minimal 8 karakter, mengandung huruf besar, kecil, dan angka"
    exit 1
fi
hash_password=$(echo -n "$password$SALT" | sha256sum | awk '{print $1}')

echo "$email,$username,$hash_password" | tee -a "$DB_FILE" > /dev/null
echo "Registrasi berhasil"
```
![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-19_21_57_13.png?raw=true)


b.Sistem login/register Email harus memiliki format yang benar dengan tanda @ dan titik, sementara password harus memiliki minimal 8 karakter, setidaknya satu huruf kecil, satu huruf besar, dan satu angka 

```sh
if [[ "$email" != *@*.* ]]; then
```

```sh
if [[ ! "$password" =~ [A-Z] || ! "$password" =~ [a-z] || ! "$password" =~ [0-9] || ${#password} -lt 8 ]]; then
```

c.Karena diperlukan pengecekan keaslian “Player” yang aktif, maka diperlukan sistem untuk pencegahan duplikasi “Player”. Jadikan sistem login/register tidak bisa memakai email yang sama (email = unique), tetapi tidak ada pengecekan tambahan untuk username.

```sh

```

d.password perlu disimpan dalam bentuk yang tidak mudah diakses. Gunakan algoritma hashing sha256sum yang memakai static salt (bebas).
```sh
hash_password=$(echo -n "$password$SALT" | sha256sum | awk '{print $1}')
```
e.melacak penggunaan cpu & model cpu

```sh
#!/bin/bash

LOG_FILE="/home/maulana/log/core.log"

WAKTU=$(date '+%Y-%m-%d %H:%M:%S')

CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\):/ {print 100 - $8}')
CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')

echo "[$WAKTU] - Core Usage [$CPU_USAGE%] - Terminal Model [$CPU_MODEL]" >> "$LOG_FILE"
```

f.memantau ram dalam bentuk persentase usage, dan juga penggunaan RAM sekarang. 

```sh
#!/bin/bash

LOG_FILE="/home/maulana/log/fragment.log"

WAKTU=$(date '+%Y-%m-%d %H:%M:%S')

RAM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')
TOTAL_RAM=$(free -m | awk 'NR==2 {print $2}')
USED_RAM=$(free -m | awk 'NR==2 {print $3}')
AVAILABLE_RAM=$(free -m | awk 'NR==2 {print $7}')

echo "[$WAKTU] - Fragment Usage [$RAM_USAGE%] - Fragment Count [$USED_RAM MB] - Details [Total: $TOTAL_RAM MB, Available: $AVAILABLE_RAM MB]" >> "$LOG_FILE"
```

g. Crontab manager (suatu menu) memungkinkan "Player" untuk mengatur jadwal pemantauan sistem. 
Hal yang harus ada di fungsionalitas menu:
Add/Remove CPU [Core] Usage
Add/Remove RAM [Fragment] Usage
View Active Jobs

```sh
#!/bin/bash

tambah_cpu_monitoring() {
    (crontab -l 2>/dev/null; echo "* * * * * /home/maulana/sisop/soal_2/scripts/core_monitor.sh  >> /home/maulana/log/core.log 2>&1") | crontab -
    echo " Pemantauan CORE ditambahkan"
}

hapus_cpu_monitoring() {
    crontab -l | grep -v "core_monitor.sh" | crontab -
    echo " Pemantauan CORE  dihapus"
}

tambah_ram_monitoring() {
    (crontab -l 2>/dev/null; echo "* * * * * /home/maulana/sisop/soal_2/scripts/frag_monitor.sh >> /home/maulana/log/fragment.log 2>&1") | crontab -
    echo " Pemantauan FRAGMENT ditambahkan"
}

hapus_ram_monitoring() {
    crontab -l | grep -v "frag_monitor.sh" | crontab -
    echo " Pemantauan FRAGMENT dihapus "
}

lihat_aktivitas() {
    echo " aktivitas yang sedang aktif:"
    crontab -l || echo "Tidak ada aktivitas aktif"
}

while true; do
    echo "*********************************"
    echo "*           ARCEA MODE          *"
    echo "*********************************"
    echo "1.  Pemantauan CORE"
    echo "2.  Hapus Pemantauan CORE"
    echo "3.  Pemantauan FRAGMENT"
    echo "4.  Hapus Pemantauan FRAGMENT"
    echo "5.  Lihat aktivitas"
    echo "6.  Keluar"
    read -p "Pilih opsi [1-6]: " choice

    case $choice in
        1) tambah_cpu_monitoring ;;
        2) hapus_cpu_monitoring ;;
        3) tambah_ram_monitoring ;;
        4) hapus_ram_monitoring ;;
        5) lihat_aktivitas ;;
        6) echo " Keluar dari arcea mode"; exit 0 ;;
        *) echo " Pilihan tidak valid, coba lagi" ;;
    esac
done
```

![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-20_21_59_26.png?raw=true)



h.buatlah 2 log file, core.log dan fragment.log di folder ./log/
```sh


```

i.Buatlah shell script terminal.sh, yang berisi user flow berikut:
Register
Login
Crontab manager (add/rem core & fragment usage)
Exit
Exit

```sh
#!/bin/bash

register() {
    ./register.sh
}

login() {
    ./login.sh
	if [ $? -eq 0 ]; then
	   crontab_manager
	fi
}

crontab_manager() {
    ./scripts/manager.sh
}

while true; do
    echo "---------------------------------"
    echo "          ARCEA SYSTEM           "
    echo "---------------------------------"
    echo "1.  Register"
    echo "2.  Login"
    echo "3.  Exit"
    read -p "Pilih opsi [1-3]: " choice

    case $choice in
        1) register ;;
        2) login ;;
        3) echo " Keluar dari sistem"; exit 0 ;;
        *) echo " Pilihan tidak valid, coba lagi" ;;
    esac
done
```
![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-20_21_58_25.png?raw=true)


## Soal 3

### Pendahuluan

Soal 3 terdiri dari lima subsoal, masing-masing dijalankan menggunakan argumen yang berbeda pada opsi/flag "--play". Adapun langkah implementasinya adalah sebagai berikut:
```sh
#!/bin/bash
```
1. Memperintah sistem untuk menggunakan bash sebagai interpreter program.
```sh
clear
```
2. Membersihkan layar terminal
```sh
while [ "$#" -gt 0 ]
do
    case "$1" in
        # ...
    esac
	shift
done
```
3. Memastikan bahwa terdapat opsi/flag yang diberikan ke program dan memprosesnya satu per satu.
```sh
--play=*)
            play="${1#*=}"
            ;;

```
4. Membuat case untuk setiap opsi/flag. Sesuai dengan perintah di soal, maka opsi/flag yang digunakan hanya satu yaitu "--play" dalam bentuk long format. Kemudian program akan menyimpan argumen yang diberikan pada variabel "play".
```sh
*)
            printf "Unknown Argument\n" >&2
```
5. Memastikan program dapat menangkap dan memproses argumen yang tidak diinginkan. Program juga dibuat agar menampilkan pesan error apabila kasus ini terjadi.

Secara keseluruhan, program pada bagian pendahuluan terlihat seperti ini:
```sh
#!/bin/bash

clear

while [ "$#" -gt 0 ]
do
    case "$1" in
        --play=*)
            play="${1#*=}"
            ;;
        *)
            printf "Unknown Argument\n" >&2
    esac
	shift
done
```

### Soal 1.A

Pada subsoal A, kita diperintahkan untuk memanggil API pada tautan tertera dan menampilkan "word of affirmation" setiap detiknya. Adapun langkah implementasinya adalah sebagai berikut:
```sh
if [ "$play" == "Speak To Me" ]
then
```
1. Membuat if-else statement untuk menjalankan kode yang sesuai dengan value dari variabel "play". Pada kasus subsoal A, value yang diperlukan adalah "Speak To Me".
```sh
until read -n 1 -t 1 -s
    do
        # ...
    done
```
2. Menjalankan command "read" yang akan membaca keypress dari user dengan ketentuan sebagai berikut:
- "-n 1"	: Command read akan hanya membaca satu karakter yang diinput oleh user pada command line.
- "-t 1"	: Command read akan mencoba membaca input dari user (jika ada) setiap 1 detik.
- "-s"	: Input user tidak akan ditampilkan pada command line atau bersifat tersembunyi.
  
Selama user tidak melakukan keypress maka command "read" tidak akan terpenuhi, dan statement "until" akan terus berjalan.
```sh
        curl -sH "Accept: application/json" "https://www.affirmations.dev" | awk -F '"' '{print $4}'
```
3. Menjalankan command "curl" yang akan memanggil API dari tautan yang diberikan dengan ketentuan sebagai berikut:
- "-s"	: Command curl hanya mengoutput data yang diperlukan. Hal seperti pesan error dan progress bar bawaan curl tidak akan ditampilkan.
- "-H"	: Memanggil API dengan custom header "Accept: application/json".
  
Namun, data yang dioutput oleh curl masih bersifat bawaan dari API-nya, sebagai contoh:
```sh
{"affirmation":"Your mind is full of brilliant ideas"}
```
Sedangkan output yang diinginkan adalah:
```sh
Your mind is full of brilliant ideas
```
Oleh karena itu, output dari command "curl" perlu dipipe ke command "awk" terlebih dahulu, dengan simbol " (Double Quotes) sebagai field separator atau pemisah datanya. Command "print" bawaan awk, secara default akan menambahkan newline diakhir string, maka tidak perlu menambahkan karakter newline diakhir.

### Soal 1.B

Pada subsoal B, kita diperintahkan untuk membuat progress bar yang akan memperbarui dalam interval random dan membentang sepanjang ukuran window terminal. Adapun langkah implementasinya adalah sebagai berikut:
```sh
elif [ "$play" == "On The Run" ]
then
```
1. Merupakan lanjutan dari if statement subsoal A, dimana pada kasus subsoal B, value yang diperlukan adalah "On The Run".
```sh
    printf "Loading...\n"
```
2. Mengoutput string pada terminal. Hanya bersifat sebagai estetika saja.
```sh
    length=$COLUMNS
    let max=$length-7
```
3. Mengambil data jumlah kolom yang dapat dipenuhi sebuah karakter terminal window saat ini. Kemudian mengurangi sebanyak 7 karakter agar dpat menampilkan persentase progress bar diakhir.
```sh
    progress=1
```
4. Mendeklarasikan variabel progress yang akan bertambah setiap karakter yang diinput.
```sh
 while true
    do
        # ...
    done
```
5. Menjalankan kode dibawahnya sampai suatu kondisi terpenuhi. Pada kasus ini, jika persentase progress bar mencapai 100%.
```sh
	let randnum=($RANDOM%10)+1
        randinterval=$( printf "scale=1; %s / 10\n" $randnum | bc )
```
6. Pada setiap iterasi while, variabel randnum akan memiliki value random antara 1-10. Namun, soal meminta intervalnya berada di antara 0.1-1. Tetapi interval ini tidak dapat diimplementasikan langsung pada bash, karena bash tidak mendukung tipe data float. Oleh karena itu, variable randnum akan dipipe terlebih dahulu ke bc supaya dapat diubah menjadi interbal yang sesuai. 
### Kendala yang Dialami

1. Pada statement if-else, awalnya perbandingan dilakukan menggunakan comparison operator "-eq". Sedangkan operator tersebut hanya bisa digunakan untuk variabel yang bash anggap sebagai integer. Untuk membandingkan string, maka diperlukan operator yang berbeda yaitu "==".

<p align="center">
	<img src="https://github.com/user-attachments/assets/ede2fb93-6f44-484f-9773-511900679152" alt="Comparison Operator Error" width="640" height="360">  
</p>
  
> Screenshot menampilkan error saat menggunakan "-eq" sebagai comparison operator.
 
## Soal 4

c. Fitur Pencarian Pokémon Berdasarkan Nama (--grep)

Fitur ini bertujuan untuk mencari Pokémon tertentu berdasarkan namanya dalam dataset pokemon_usage.csv, dengan memastikan pencarian tidak menampilkan hasil yang tidak relevan. Hasil pencarian juga akan diurutkan berdasarkan Usage% untuk mempermudah analisis.

```bash
#!/bin/bash
elif [ "$COMMAND" == "--grep" ]; then
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <pokemon_usage.csv> --grep <pokemon_name>"
        exit 1
    fi

    POKEMON_NAME=$3

    # header
    head -n 1 "$FILE"

    # Cari Pokémon dengan nama yang tepat
    awk -F',' -v name="$POKEMON_NAME" 'NR > 1 && tolower($1) == tolower(name)' "$FILE"

```
d. Mencari Pokémon Berdasarkan Type dan Sort Berdasarkan Usage%

Fitur --filter ini memungkinkan pencarian Pokémon berdasarkan Type1 atau Type2, dan hasilnya akan diurutkan berdasarkan Usage% (kolom ke-2).

```bash
#!/bin/bash

FILE=$1
COMMAND=$2  # Perintah (--filter)

if [ "$COMMAND" == "--filter" ]; then
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <pokemon_usage.csv> --filter <type_name>"
        exit 1
    fi

    TYPE_NAME=$3

    # Cetak header
    head -n 1 "$FILE"

    # Cari Pokémon berdasarkan Type1 atau Type2 dan urutkan berdasarkan Usage%
    awk -F',' -v type="$TYPE_NAME" '
        NR == 1 { next }  # Lewati header
        tolower($4) == tolower(type) || tolower($5) == tolower(type) { print }
    ' "$FILE" | sort -t',' -k2 -nr
fi
```
## REVISI

C.“Unceasing Spirit”
Karena diperlukan pengecekan keaslian “Player” yang aktif, maka diperlukan sistem untuk pencegahan duplikasi “Player”. Jadikan sistem login/register tidak bisa memakai email yang sama (email = unique), tetapi tidak ada pengecekan tambahan untuk username.

```sh
if grep -q "^$email," "$DB_FILE"; then
    echo "Email sudah terdaftar!"
    exit 1
fi
```


