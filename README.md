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


h. buatlah 2 log file, core.log dan fragment.log di folder ./log/, yang dimana masing-masing terhubung ke program usage monitoring untuk usage tersebut. 
Format log:
CPU
[YYYY-MM-DD HH:MM:SS] - Core Usage [$CPU%] - Terminal Model [$CPU_Model]

RAM
[YYYY-MM-DD HH:MM:SS] - Fragment Usage [$RAM%] - Fragment Count [$RAM MB] - Details [Total: $TOTAL MB, Available: $AVAILABLE MB]

![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-20_22_08_07.png?raw=true)

![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-20_22_08_29.png?raw=true)

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



## kendala 
terkadang di bagian log outputnya eror

![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-20_22_14_40.png?raw=true)

![alt text](https://github.com/jagosyafaat30/dokumetnsasi/blob/main/Screenshot_2025-03-20_22_14_33.png?raw=true)




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
5. Memastikan program dapat menangkap dan memproses argumen yang tidak diinginkan. Program juga dibuat agar mengoutput pesan error ke stderr apabila kasus ini terjadi.

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

### Soal 3.A

Pada subsoal A, kita diperintahkan untuk memanggil API pada tautan tertera dan menampilkan "word of affirmation" setiap detiknya. Adapun langkah implementasinya adalah sebagai berikut:
```sh
if [ "$play" == "Speak To Me" ]
then
```
1. Membuat if-else statement untuk menjalankan kode yang sesuai dengan value dari variabel "play". Pada kasus subsoal A, value yang perlu dicompare adalah "Speak To Me".
```sh
until read -n 1 -t 1 -s
do
	# ...
done
```
2. Menjalankan command "read" yang akan membaca keypress dari user dengan ketentuan sebagai berikut:
* `-n 1` Command read akan hanya membaca 1 karakter yang diinput oleh user pada command line.
* `-t 1` Command read akan mencoba membaca input dari user (jika ada) setiap 1 detik.
* `-s` Input user tidak akan ditampilkan pada command line atau bersifat tersembunyi.
  
Selama user tidak melakukan keypress maka command "read" tidak akan terpenuhi, dan statement "until" akan terus berjalan.
```sh
curl -sH "Accept: application/json" "https://www.affirmations.dev" | awk -F '"' '{print $4}'
```
3. Menjalankan command "curl" yang akan memanggil API dari tautan yang diberikan dengan ketentuan sebagai berikut:
* `-s` Command curl hanya mengoutput data yang diperlukan. Hal seperti pesan error dan progress bar bawaan curl tidak akan ditampilkan.
* `-H` Memanggil API dengan custom header "Accept: application/json".
  
Namun, data yang dioutput oleh curl masih bersifat bawaan dari API-nya, sebagai contoh:
```sh
{"affirmation":"Your mind is full of brilliant ideas"}
```
Sedangkan output yang diinginkan adalah:
```sh
Your mind is full of brilliant ideas
```
Oleh karena itu, output dari command "curl" perlu dipipe ke command "awk" terlebih dahulu, dengan simbol " (Double Quotes) sebagai field separator atau pemisah datanya. Command "print" bawaan awk, secara default akan menambahkan newline diakhir string, maka tidak perlu menambahkan karakter newline diakhir.  

Secara keseluruhan, program pada bagian 3.A terlihat seperti ini:
```sh
if [ "$play" == "Speak To Me" ]
then
    until read -n 1 -t 1 -s
    do
        curl -sH "Accept: application/json" "https://www.affirmations.dev" | awk -F '"' '{print $4}'
    done
```

### Soal 3.B

Pada subsoal B, kita diperintahkan untuk membuat progress bar yang akan memperbarui dirinya sendiri dengan interval random dan membentang sepanjang ukuran window terminal. Adapun langkah implementasinya adalah sebagai berikut:
```sh
elif [ "$play" == "On The Run" ]
then
```
1. Merupakan lanjutan dari if statement subsoal A, dimana pada kasus subsoal B, value yang perlu dicompare adalah "On The Run".
```sh
printf "Loading...\n"
```
2. Mengoutput string pada stdout. Hanya bersifat sebagai estetika saja.
```sh
length=$COLUMNS
let max=$length-7
```
3. Mengambil data jumlah kolom yang dapat dipenuhi sebuah karakter terminal window saat ini. Kemudian mengurangi sebanyak 7 karakter agar dpat menampilkan persentase progress bar diakhir.
```sh
progress=1
```
4. Mendeklarasikan variabel progress yang merepresentasikan setiap karakter pada baris terminal yang dapat diisi oleh progress bar.
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
6. Pada setiap iterasi while, variabel randnum akan memiliki value random antara 1-10. Namun, soal meminta intervalnya berada di antara 0,1-1. Tetapi interval ini tidak dapat diimplementasikan langsung pada bash, karena bash tidak mendukung tipe data float.

Oleh karena itu, variable randnum akan dipipe terlebih dahulu ke command "bc" (Basic Calculator) supaya dapat diubah menjadi interval yang sesuai.
```sh
let percent=$progress*100/$max
```
7. Tidak semua window terminal tepat memiliki 100 karakter yang dapat diisi oleh progress bar. Oleh karena itu, variabel percent digunakan sebagai perbandingan antara progress dengan jumlah karakter maksimum yang dapat diisi oleh progress bar.
```sh
if [ $percent -gt 100 ]
	then
            printf "\nFinished!\n"
            break
```
8. Membuat if statement untuk mengakhiri program jika persentase sudah mencapai 100%.
```sh
else
	((progress++))
	printf "\r[\e[%dG■" $progress
	# ...
fi
```
9. Jika belum 100% maka progress akan bertambah dan akan mengoutput simbol "■" yang merepresentasikan visualisasi progress bar pada stdout, dengan ketentuan sebagai berikut:
* `\r` Carriage return, dimana daripada membuat newline, setiap iterasi while akan mengupdate baris yang sudah ada.
* `\e%dG` Escape sequence untuk memindahkan kursor yang akan mengoutput simbol "■" pada stdout satu karakter ke kanan sesuai value variabel progress setiap iterasi while.
```sh
printf "\e[%dG] %d%%" $max $percent
```
10. Menampilkan "] XX%" di ujung terminal sebagai aspek estetika, sekaligus alasan mengapa jumlah karakter maksimum suatu kolom harus dikurangi tepat 7 karakter.
```sh
sleep $randinterval
```
11. Karena nilai interval akan berubah setiap iterasi, kurang efisien jika menggunakan statement "until". Maka dari itu, pada subsoal ini digunakan command "sleep" yang memiliki fungsi sama, hanya saja tidak akan berhenti jika user melakukan keypress.

Secara keseluruhan, program pada bagian 3.B terlihat seperti ini:
```sh
elif [ "$play" == "On The Run" ]
then
    printf "Loading...\n"
    length=$COLUMNS
    let max=$length-7
    progress=1
    while true
    do
        let randnum=($RANDOM%10)+1
        randinterval=$( printf "scale=1; %s / 10\n" $randnum | bc )
        let percent=$progress*100/$max
        if [ $percent -gt 100 ]
        then
            printf "\nFinished!\n"
            break
        else
            ((progress++))
            printf "\r[\e[%dG■" $progress
            printf "\e[%dG] %d%%" $max $percent
            sleep $randinterval
        fi
    done
```

### Soal 3.C

Pada subsoal C, kita diperintahkan untuk membuat membuat live clock yang akan memperbarui dirinya sendiri setiap detik. Adapun langkah implementasinya adalah sebagai berikut:
```sh
elif [ "$play" == "Time" ]
then
```
1. Merupakan lanjutan dari elif statement subsoal B, dimana pada kasus subsoal C, value yang perlu dicompare adalah "Time".
```sh
until read -n 1 -t 1 -s
do
        # ...
done
```
2. Menjalankan command "read" yang akan membaca keypress dari user dengan ketentuan sebagai berikut:
* `-n 1` Command read akan hanya membaca 1 karakter yang diinput oleh user pada command line.
* `-t 1` Command read akan mencoba membaca input dari user (jika ada) setiap 1 detik.
* `-s` Input user tidak akan ditampilkan pada command line atau bersifat tersembunyi.
  
Selama user tidak melakukan keypress maka command "read" tidak akan terpenuhi, dan statement "until" akan terus berjalan.
```sh
awk '/rtc_date/ {date=$3} /rtc_time/ {time=$3} END {printf "\r%s %s", date, time}' /proc/driver/rtc
```
3. Mengambil data kolom ketiga dari baris yang terdapat "rtc_date" dan "rtc_time" yang berada di dalam file /proc/driver/rtc kemudian mengoutputnya ke stdout dalam format "YYYY-MM-DD HH:MM:SS".
```sh
printf "\n"
```
4. Membuat line baru.

Secara keseluruhan, program pada bagian 3.C terlihat seperti ini:
```sh
elif [ "$play" == "Time" ]
then
    until read -n 1 -t 1 -s
    do
        awk '/rtc_date/ {date=$3} /rtc_time/ {time=$3} END {printf "\r%s %s", date, time}' /proc/driver/rtc
    done
    printf "\n"
```

### Soal 3.D

Pada subsoal D, kita diperintahkan untuk membuat sebuah program imitasi cmatrix tetapi dengan menggunakan simbol mata uang sebagai efeknya. Adapun langkah implementasinya adalah sebagai berikut:
```sh
elif [ "$play" == "Money" ]
then
```
1. Merupakan lanjutan dari elif statement subsoal C, dimana pada kasus subsoal D, value yang perlu dicompare adalah "Money".
```sh
symbols=("$" "€" "¥" "₤" "£" "¢" "฿" "₱" "₹" "₩" "₿" "₣")
```
2. Membuat sebuah array dengan nama symbol yang berisi simbol-simbol mata uang yang akan ditampilkan pada program.
```sh
until read -n 1 -t 0.001 -s
do
	# ...
done
```
3. Menjalankan command "read" yang akan membaca keypress dari user dengan ketentuan sebagai berikut:
* `-n 1` Command read akan hanya membaca 1 karakter yang diinput oleh user pada command line.
* `-t 0.001` Command read akan mencoba membaca input dari user (jika ada) setiap 0.001 detik. Digunakan untuk mengatur kecepatan kecepatan program berjalan secara keseluruhan.
* `-s` Input user tidak akan ditampilkan pada command line atau bersifat tersembunyi.  
  
Selama user tidak melakukan keypress maka command "read" tidak akan terpenuhi, dan statement "until" akan terus berjalan.
```sh
printf "\e[%d\n" $LINES
```
4. Memindahkan kursor ke baris terakhir pada window terminal dan mengoutput satu karakter newline. Digunakan untuk menggeser layar ke bawah setiap iterasi until untuk menghindari akumulasi simbol pada window terminal.
```sh
let randrow=$RANDOM%$LINES+1
let randcol=$RANDOM%$COLUMNS+1
```
5. Memilih posisi kolom dan baris pada window terminal secara random untuk diletakkan simbol.
```sh
let randsym=$RANDOM%${#symbols[@]}
let randclr=($RANDOM%5)+53
```
6. Memilih simbol secara random yang ada di dalam array simbol dan memilih warnanya secara random. Pada kasus ini, warna yang dipilih adalah warna dengan color index rentang 53-57 yaitu sebuah gradien warna biru-ungu.
```sh
printf "\e[%d;%dH\e[1;38;5;%dm%s" $randrow $randcol $randclr ${symbols[randsym]}
```
7. Meletakkan simbol yang dipilih secara random dengan warna random pada kolom dan baris random window terminal. Adapun penjelasan escape sequencenya:
* `\e[%d;%dH` Escape sequence untuk memindahkan kursor ke kolom dan baris random yang akan mengoutput simbol mata uang ke stdout.
* `\e[1;38;5;%dm%s` Escape sequence untuk menampilkan simbol mata uang dengan style **bold** dan warna dengan color index ID random.
```sh
printf "\e[0m\n"
```
8. Mengatur ulang style dan warna terminal ke setelan awal dan membuat line baru.

Secara keseluruhan, program pada bagian 3.D terlihat seperti ini:
```sh
elif [ "$play" == "Money" ]
then
    symbols=("$" "€" "¥" "₤" "£" "¢" "฿" "₱" "₹" "₩" "₿" "₣")
    until read -n 1 -t 0.001 -s
    do
        printf "\e[%d\n" $LINES
        let randrow=$RANDOM%$LINES+1
        let randcol=$RANDOM%$COLUMNS+1
        let randsym=$RANDOM%${#symbols[@]}
        let randclr=($RANDOM%5)+53
        printf "\e[%d;%dH\e[1;38;5;%dm%s" $randrow $randcol $randclr ${symbols[randsym]}
    done
    printf "\e[0m\n"
```

### Soal 3.E

Pada subsoal E, kita diperintahkan untuk membuat sebuah program imitasi ps/top/htop. Adapun langkah implementasinya adalah sebagai berikut:
```sh
elif [ "$play" == "Brain Damage" ]
then
```
1. Merupakan lanjutan dari elif statement subsoal D, dimana pada kasus subsoal E, value yang perlu dicompare adalah "Brain Damage".
```sh
until read -n 1 -t 1 -s
do
        # ...
done
```
2. Menjalankan command "read" yang akan membaca keypress dari user dengan ketentuan sebagai berikut:
* `-n 1` Command read akan hanya membaca 1 karakter yang diinput oleh user pada command line.
* `-t 1` Command read akan mencoba membaca input dari user (jika ada) setiap 1 detik.
* `-s` Input user tidak akan ditampilkan pada command line atau bersifat tersembunyi.
  
Selama user tidak melakukan keypress maka command "read" tidak akan terpenuhi, dan statement "until" akan terus berjalan.
```sh
printf "\e[0;0H"
```
3. Memindahkan kursor ke kolom ke-0 dan baris ke-0 (Posisi home kursor).
```sh
awk '{printf "\033[1;38;5;30mSystem Uptime: %02d:%02d:%02d:%02d\n", $1/3600/24, $1/3600%24, $1/60%60, $1%60}' /proc/uptime
```
4. Mengambil data sistem uptime dalam satuan detik yang berada di dalam file /proc/uptime kemudian mengolahnya untuk mendapatkan jumlah hari, jam, menit, dan detik yang sesuai sebelum mengoutputnya ke stdout dalam format "System Update: DD:HH:MM:SS".

Adapun `\033[1;38;5;30m` merupakan escape sequence untuk menampilkan output dengan style **bold** dan warna dengan color index ID 30 dalam format octal (`\033`), karena command "awk" tidak mendukung format `\e` milik C.
```sh
awk '
            {if ($3 == "R" || $3 == "S" || $3 == "Z" || $3 == "T" || $3 == "I") {count[$3]++;total++}}
            END {
                printf "\033[38;5;66mTasks: %d total, %d running, %d sleeping, %d zombie, %d stopped, %d idle", total, count["R"], count["S"], count["Z"], count["T"], count["I"]
            }
        ' /proc/*/stat 2>/dev/null
```
5. Mengambil data proses-proses yang ada dengan status running, sleeping, zombie, stopped, atau idle yang berada di dalam folder /proc/ kemudian menghitung jumlah proses secara keseluruhan dan pada masing-masing kategori status sebelum mengoutputnya ke stdout dengan warna color index ID 66.

Adapun `/proc/*/stat 2>/dev/null` digunakan untuk mengatasi proses-proses yang tidak bisa dibaca statusnya (stderr) dan membuangnya ke /dev/null.
```sh
awk '
        /MemTotal/ {memtotal=$2} /MemFree/ {memfree=$2} /MemAvailable/ {avail=$2} /Buffers/ {buffers=$2} /Cached/ {cached=$2} /Slab/ {slab=$2} /SwapTotal/ {swatotal=$2} /SwapFree/ {swafree=$2}
        END {
            buffcache=buffers+cached+slab
            memused=memtotal-memfree-buffcache
            printf "\033[38;5;102m\n\n\ttotal\t\tfree\t\tused\t\tavailable\tbuff/cache"
            printf "\033[38;5;138m\nMemory:\t%.1f MiB\t%.1f MiB\t%.1f MiB\t%.1f MiB\t%.1f MiB", memtotal/1024, memfree/1024, memused/1024, avail/1024, buffcache/1024
            swaused=swatotal-swafree
            printf "\nSwap:\t%.1f MiB\t%.1f MiB\t%.1f MiB", swatotal/1024, swafree/1024, swaused/1024

        }' /proc/meminfo
```
6. Mengambil data yang berhubungan dengan memori yang berada di dalam file /proc/meminfo kemudian memproses datanya sebelum mengoutputnya ke stdout dengan warna color index ID 102 dan ID 138.
```sh
printf "\e[38;5;174m\n\nPID\tUSER\tSTATUS\t%%CPU\tCOMMAND\n\n"
```
7. Mengoutput heading untuk kolom PID, USER, STATUS, %CPU, dan COMMAND ke stdout dengan warna color index ID 174.
```sh
limit=0
```
8. Mendeklarasikan variabel limit yang merepresentasikan batas seberapa banyak proses yang dapat ditampilkan ke window terminal.
```sh
for proc in /proc/*/stat
do
	status=$( awk '{print $3}' $proc 2>/dev/null)
	if [ "$status" == "R" ] || [ "$status" == "S" ] || [ "$status" == "Z" ] || [ "$status" == "T" ] || [ "$status" == "I" ]
	then
		# ...
	fi
	# ...
done
```
9. Mengiterasi untuk setiap proses yang ditemukan di folder /proc/ dengan status running, sleeping, zombie, stopped, atau idle.
```sh
pid=$( awk '{print $1}' $proc 2>/dev/null)
# ...
cmdname=$(awk '{print $2}' $proc 2>/dev/null)
# ...
utime=$(awk '{print $14}' $proc 2>/dev/null)
stime=$(awk '{print $15}' $proc 2>/dev/null)
starttime=$(awk '{print $22}' $proc 2>/dev/null)
```
10. Mengambil data PID, command name, utime, stime, dan start time setiap proses pada folder /proc/ dan menyimpannya ke variabel masing-masing.
```sh
user=$(ls -l $proc | awk '{print $3}' 2>/dev/null)
```
11. Mengambil data user yang menjalankan masing-masing proses yang muncul ketika menjalankan command "ls -l" dan menyimpannya ke variabel user.
```sh
uptime=$(awk '{print $1}' /proc/uptime)
```
12. Mengambil data sistem uptime dalam satuan detik yang berada di dalam file /proc/uptime dan menyimpannya ke variabel uptime.
```sh
ticks=$(getconf CLK_TCK)
```
13. Mengambil data Hertz (jumlah clock ticks setiap detik) sistem dan menyimpannya ke variabel ticks.
```sh
let timespent=$utime+$stime
elapsedtime=$( printf "scale=1; %s - (%s / %s)\n" $uptime $starttime $ticks | bc)
cpuusage=$( printf "scale=1; 100 * ((%s / %s) / %s)\n" $timespent $ticks $elapsedtime | bc )
```
14. Memproses data untuk mendapatkan CPU Usage suatu proses.
```sh
printf "\e[38;5;210m%d\t%s\t%s\t%.1f\t%s\e[K\n" $pid $user $status $cpuusage $cmdname
```
15. Mengoutput data PID, User, Status, CPU Usage, dan Command Name setiap proses ke stdout dengan warna color index ID 210.
```sh
((limit++))
```
16. Menghitung jumlah proses yang sudah ditampilkan di window terminal agar dapat dibatasi banyaknya.
```sh
if [ $limit -gt 30 ]
then
	break
fi
```
17. Jika proses yang ditampilkan sudah mencapai 30 (arbitrary number, tidak ada alasan teknikal mengapa memilih angka tersebut), maka program tidak akan menampilkan proses selanjutnya pada window terminal. Hal ini dilakukan supaya program bisa memperbarui dirinya sendiri setiap detik tanpa ada kendala.
```sh
printf "\e[0m\n"
```
18. Mengatur ulang style dan warna terminal ke setelan awal dan membuat line baru.
```sh
else
    printf "Unknown Argument\n" >&2
fi
```
19. Merupakan lanjutan dari elif statement subsoal E, dimana jika value dari variabel "play" tidak memenuhi value if-elif apapun, maka program akan mengoutput pesan error ke stderr.

Secara keseluruhan, program pada bagian 3.E terlihat seperti ini:
```sh
elif [ "$play" == "Brain Damage" ]
then
    until read -n 1 -t 1 -s
    do
        printf "\e[0;0H"
        awk '{printf "\033[1;38;5;30mSystem Uptime: %02d:%02d:%02d:%02d\n", $1/3600/24, $1/3600%24, $1/60%60, $1%60}' /proc/uptime
        awk '
            {if ($3 == "R" || $3 == "S" || $3 == "Z" || $3 == "T" || $3 == "I") {count[$3]++;total++}}
            END {
                printf "\033[38;5;66mTasks: %d total, %d running, %d sleeping, %d zombie, %d stopped, %d idle", total, count["R"], count["S"], count["Z"], count["T"], count["I"]
            }
        ' /proc/*/stat 2>/dev/null
        awk '
        /MemTotal/ {memtotal=$2} /MemFree/ {memfree=$2} /MemAvailable/ {avail=$2} /Buffers/ {buffers=$2} /Cached/ {cached=$2} /Slab/ {slab=$2} /SwapTotal/ {swatotal=$2} /SwapFree/ {swafree=$2}
        END {
            buffcache=buffers+cached+slab
            memused=memtotal-memfree-buffcache
            printf "\033[38;5;102m\n\n\ttotal\t\tfree\t\tused\t\tavailable\tbuff/cache"
            printf "\033[38;5;138m\nMemory:\t%.1f MiB\t%.1f MiB\t%.1f MiB\t%.1f MiB\t%.1f MiB", memtotal/1024, memfree/1024, memused/1024, avail/1024, buffcache/1024
            swaused=swatotal-swafree
            printf "\nSwap:\t%.1f MiB\t%.1f MiB\t%.1f MiB", swatotal/1024, swafree/1024, swaused/1024

        }' /proc/meminfo
        printf "\e[38;5;174m\n\nPID\tUSER\tSTATUS\t%%CPU\tCOMMAND\n\n"
        limit=0
        for proc in /proc/*/stat
        do
            status=$( awk '{print $3}' $proc 2>/dev/null)
            if [ "$status" == "R" ] || [ "$status" == "S" ] || [ "$status" == "Z" ] || [ "$status" == "T" ] || [ "$status" == "I" ]
            then
                pid=$( awk '{print $1}' $proc 2>/dev/null)
                user=$(ls -l $proc | awk '{print $3}' 2>/dev/null)
                cmdname=$(awk '{print $2}' $proc 2>/dev/null)
                uptime=$(awk '{print $1}' /proc/uptime)
                utime=$(awk '{print $14}' $proc 2>/dev/null)
                stime=$(awk '{print $15}' $proc 2>/dev/null)
                starttime=$(awk '{print $22}' $proc 2>/dev/null)
                ticks=$(getconf CLK_TCK)
                let timespent=$utime+$stime
                elapsedtime=$( printf "scale=1; %s - (%s / %s)\n" $uptime $starttime $ticks | bc)
                cpuusage=$( printf "scale=1; 100 * ((%s / %s) / %s)\n" $timespent $ticks $elapsedtime | bc )
                printf "\e[38;5;210m%d\t%s\t%s\t%.1f\t%s\e[K\n" $pid $user $status $cpuusage $cmdname
                ((limit++))
            fi
            if [ $limit -gt 30 ]
            then
                break
            fi
        done
    done
    printf "\e[0m\n"
else
    printf "Unknown Argument\n" >&2
fi
```

### Kendala yang Dialami

1. Pada statement if-else, awalnya perbandingan dilakukan menggunakan comparison operator "-eq". Sedangkan operator tersebut hanya bisa digunakan untuk variabel yang bash anggap sebagai integer. Untuk membandingkan string, maka diperlukan operator yang berbeda yaitu "==".

<p align="center">
	<img src="https://github.com/user-attachments/assets/ede2fb93-6f44-484f-9773-511900679152" alt="Comparison Operator Error" width="640" height="360">  
</p>
  
> Screenshot menampilkan error saat menggunakan "-eq" sebagai comparison operator.

2. Pada subsoal B, pada bagian mendapatkan interval 0.1-1 detik, bash akan mengoutput error apabila kita mencoba untuk melakukan pembagian yang menghasilkan sebuah float. Hal ini karena bash tidak mendukung tipe data float. Sehingga solusi yang ditawarkan adalah melakukan perhitungannya diluar bash, khususnya pada command "bc" atau Basic Calculator.

<p align="center">
	<img src="https://github.com/user-attachments/assets/f867a1f7-95a5-4e66-81de-caec6d379dc8" alt="Floating Point Error" width="640" height="360">  
</p>

> Screenshot menampilkan error saat mencoba membagi hasil $RANDOM%10+1 dengan 10.

3. Pada subsoal E, pada bagian command "awk" untuk mengambil data status setiap proses pada folder /proc/, terkadang awk akan menemukan file yang tidak bisa dibaca (stderr). Maka dari itu, file-file ini lebih baik dibuang saja ke /dev/null.

<p align="center">
	<img src="https://github.com/user-attachments/assets/e1d7dec1-00ef-42f9-b664-460a3b28cd84" alt="/proc/*/stat Error" width="640" height="360">  
</p>

> Screenshot menampilkan error saat command "awk" menemukan file dalam folder /proc/ yang tidak bisa dibaca.

4. Kendala Lain:
* Program subsoal E akan menjadi lambat bahkan tidak berfungsi sebagaimana mestinya apabila program yang ada jumlahnya sangat banyak (Pada kasus ini ratusan). Oleh karena itu, dibuatlah sebuah arbitrary limit untuk menampilkan hanya 10 proses yang sedang berjalan saja.
* Program:
```sh
awk '
	{if ($3 == "R" || $3 == "S" || $3 == "Z" || $3 == "T" || $3 == "I") {count[$3]++;total++}}
	# ...
' /proc/*/stat 2>/dev/null
```
akan memiliki output berbeda jika ditulis seperti ini:
```sh
awk '
	{
		if ($3 == "R" || $3 == "S" || $3 == "Z" || $3 == "T" || $3 == "I") {
			count[$3]++
			total++
		}
	}
	# ...
' /proc/*/stat 2>/dev/null
```
* Di beberapa tempat, escape sequence carraige return (`\r`), tidak berfungsi dan program akan tetap memperbarui datanya pada line baru. Oleh karena itu, beberapa kasus mengimplementasikan `\e[0;0H` sebagai alternatif.

## Soal 4

### Soal 4.A: Melihat summary dari data

Untuk mengetahui Pokemon apa yang sedang membawa teror kepada lingkungan “Generation 9 OverUsed” anda berusaha untuk membuat sebuah fitur untuk menampilkan nama Pokemon dengan Usage% dan RawUsage paling tinggi.

```sh
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
```

### Soal 4.B: Mengurutkan Pokemon berdasarkan data kolom

Untuk memastikan bahwa anda mengetahui kondisi lingkungan “Generation 9 OverUsed”, anda berusaha untuk membuat sebuah fitur untuk sort berdasarkan:
Usage%
RawUsage
Nama
HP
Atk
Def
Sp.Atk
Sp.Def
Speed
```sh
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
```

### Soal 4.C: Fitur Pencarian Pokémon Berdasarkan Nama (--grep)

Fitur ini bertujuan untuk mencari Pokémon tertentu berdasarkan namanya dalam dataset pokemon_usage.csv, dengan memastikan pencarian tidak menampilkan hasil yang tidak relevan. Hasil pencarian juga akan diurutkan berdasarkan Usage% untuk mempermudah analisis.

```bash
#!/bin/bash

FILE=$1
COMMAND=$2 

if [ "$COMMAND" == "--grep" ]; then
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <pokemon_usage.csv> --grep <pokemon_name>"
        exit 1
    fi

    POKEMON_NAME=$3

    head -n 1 "$FILE"

    awk -F',' -v name="$POKEMON_NAME" 'NR == 1 { next }  # Lewati header tolower($1) == tolower(name) { print } ' "$FILE" | sort -t',' -k2 -nr
fi

```
Untuk menjalankan program tersebut, gunakan command seperti berikut :

	./pokemon_analysis.sh pokemon_usage.csv --grep Chansey
 
### Soal 4.D: Mencari Pokémon Berdasarkan Type dan Sort Berdasarkan Usage%

Fitur --filter ini memungkinkan pencarian Pokémon berdasarkan Type1 atau Type2, dan hasilnya akan diurutkan berdasarkan Usage% (kolom ke-2).

```bash
#!/bin/bash

FILE=$1
COMMAND=$2 

if [ "$COMMAND" == "--filter" ]; then
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 <pokemon_usage.csv> --filter <type_name>"
        exit 1
    fi

    TYPE_NAME=$3

    head -n 1 "$FILE"

    awk -F',' -v type="$TYPE_NAME" 'NR == 1 { next }  # Lewati header tolower($4) == tolower(type) || tolower($5) == tolower(type) { print } ' "$FILE" | sort -t',' -k2 -nr
fi
```

Untuk menjalankan program tersebut, gunakan command seperti berikut :

	./pokemon_analysis.sh pokemon_usage.csv --filter Fighting

### Kendala yang Dialami
1. Pada awalnya subsoal B, akan dibuat murni menggunakan bash tanpa menggunakan command eksternal seperti "sort". Gambaran implementasinya adalah data diurutkan dengan menggunakan sorting algorithm seperti Bubble Sort. Namun pada kenyataannya, dalam mewujudkan implementasi, terdapat berbagai kendala, seperti:
 * Kerumitan dan ketidakpahaman mengenai bahasa bash untuk menerapkan sorting algorithm layaknya di C/C++.
 * Keterbatasan waktu untuk mengerjakannya.
 * Kerumitan dalam mengimplementasi program untuk mengcompare string secara lexicographic pada bash.
 * Kerumitan dalam mendeklarasikan dan menerapkan array jika data suatu kolom diambil menggunakan command "awk". 
Sehingga berdasarkan faktor-faktor tersebut, subsoal B dengan berat hati dialihkan untuk menggunakan command "sort".
  
## REVISI

### Soal 2.C: “Unceasing Spirit”
Karena diperlukan pengecekan keaslian “Player” yang aktif, maka diperlukan sistem untuk pencegahan duplikasi “Player”. Jadikan sistem login/register tidak bisa memakai email yang sama (email = unique), tetapi tidak ada pengecekan tambahan untuk username.

```sh
if grep -q "^$email," "$DB_FILE"; then
    echo "Email sudah terdaftar!"
    exit 1
fi
```

### Soal 4C-F:

```sh
#!/bin/bash

clear

# ASCII Art
cat << "EOF"
55555555YYYYYYYYYYYYYYYYYYYYYYYYYYYYJJJJJJJYYYYYYYYYYYYYYYYYYYYYYYYYYYYJYBBB########################
YYY5P5Y55PGGBBGP5YYYYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?YBB#BYYGBBBBB#BBBBBBBB#BBBBB
YPGBBBB########BBBBBBBBGGP5JJJJJJJJJJJJJJYJJJJJJJJJJJJJJJJJJJ???????????YBB#GJJP#B555PBBBBBBBB######
B########################BGP5YJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ????????????J#B#GJJG#YJJJY5#BBBBBBBB####
####################BBBBB#####G5YJJJJJJJJJJJJJJJJJJ?????J????????????????P5P5JYY#GY5JJJ5#B#BBBB#####
##################BBBBBBBBBB###B5JJJJJJ???????????????????????????????????JPYYYYYBBPPJJYGPP#BBB#####
####BGP5PB###BBBB################P??????????????????????????????????????J?JGJYYYYYBBBYJJ5GJ5#BBBBBBB
BB#BYYYJJJY5PP5YYY5GBPB##PGB##B###PJ???????????????????????????????????????P5JYYYY5B#PJYYGYYG#BBBBBB
B#B5YYJY555YYY55YYJYPYJPGJJJGBYJG###P5PJ????????????????????????????????????G5JYYYJPBBJJJP5YP#BBBBBB
#GY5PYJJJYY?77PBBYP5Y5JJYG555YJJJPGB#PJ???????????????????JYY555555YYJ?????7PPJYYYYJPGJYJGYJG5B#BBBB
PPG5JJJJJJJYYYY5YYJJJYYJPPJPBG5555YGJ??????????????????J5GBBBBBB#####BBPJ??JBJYYYYY5GJJY5GYPPJYB#B#B
5GYJJJJJJJJJJJYYYYYYJJJYJYPYYYYJBYPY?????????????????YGB#BBBBBBBBBBBBB###BYG5JYYYYYGJJJYBGP55PYYPBBB
PPJJJYGGJJJJJJJJYYYYJJJYJJP55JJJYPG?????????????????PBBBBBBBBBBBBBBBBBB#####YJYYYYYGJY5G5YYYY5GYYYPG
5PJJJJJPP5YJJJJJJYYYY55YJJ5GJ?JP5YP???????????????75#BGPPBB#BBBBBBBB#BBGG#B&YJYYYYYPP5PYYYYYYYY55YYY
YYJJJJJJJY555YYYYYYYYY5P555JY5PY?5Y7????77??JJ?7?77GBBYYYY55GBB##BBGPYJ??5B#5JJYYYYYYYYYYYYYP5YY5YYY
YYJJJJJJJJJJJJJJJJJJJJJYYYYYYYJ?557?7?7???Y5555J??7G#5Y5PP5J?JY55YJ??J55YJB#PJJYYYYYYYYYYYYJP5YYYYYY
YYJJJJJJJJJJJJJJJJJJJJJJJJJ??J?5G7?7J5Y5555P555Y555G#YGBGB#BBGPJ??YPBBGG#PB#BJJYYYYYYYYYYYYJG5YYYYYY
YYJJJJJJJJJJJJJJJJJJJJJJJJJYY?YB?7?7?Y5PPPP5555555G5B555?BGBGGPJJJGBGBP5Y5GY#YJYYYYYYYYYYYYYB5YYY5PP
YYJJJJJJJJJJJJJJJY555YYYYJJYJ?PY7?7??J5PPPGPY55YJJGGB55YJ5PYJYY?YJJJJGP5J5PYGP?JYYYYYYYYYYJY#PPGPP55
YYJJJJJJJJJJJJJJJJYYYYYYYJJJJYB?7?7?555PPPPPYJ5PPPGGG5YYYJ????J?5??JJJJ??GGP?BYJYYYYYYYYJY5GBP55Y5PP
YYJJJJJJJJJJJJJJJJJJJJJJJJJJ?PP?JJYY5P5PGP5YJYY5P5YGGGYYJ?J??JYJYJ??????YG5?7YB?JJYYJJJYPGG5Y55PPP55
YYJJJJJJJJJJJJJJJJJJJJJJJJJJ?GJ75PPGGGPGGGGPPGPY5P5PP#5JJJ?JJJYYJJJJ???JG5?7?5#5YYYYY5GBP55PPP5YYYYY
YYJJJJJJJJJJJJJJJJJJJJJJJJJJ?G?77Y55Y5PGGPGGGP55PPYJYBBY?JJJYYYJYY5JJJJGGPGP55YYYYYYYY5555GGGPPP5YYY
PYYJJJJJJJJJJJJJJJJJJJJJJJJJ?G??55PP5555P5Y5Y5G5JJJ?PGGG5J?JY555YYY5YY5PPP5YYYYJJJJJ?????JYJJ?JY5PPP
&PYJJJJJJJJJJJJJJJJJJJJJJJJJ?G?5GGGP5P55P55PG5JJJJJ?PGPPBBPP5J??????????????JJJYYYYY55J???????????J5
5PGYJJJJJJJJJJJJJJJJJJJJJJJJ?G?J5GGGPPPGGPBPJJJJJJ?J#BGBBBP5YYYY55YYYYJJJ????????????JY55J???????YYJ
??5GYJJJJJJJJJJJJJJJJJJJJJJJJBBGPPGGGGPP5G5?JJJJJY5P5YJJJJJJJJJJJJJJJJYY5555YJ????J?????J5P5Y????JYJ
JJ?YG5JJJJJJJJJJJJJJJJJJJJJ?Y#BBB#BG5YJ?P5YY5PPPP5YJ??????????????????????JJY55J???????JYJJY555J????
JJJ?JPGYJ?JJJJJJJJJJJJJJJJ??P#BBBBBBB#GJYYY5PPYJY55YYYYYYY5YYJJ???????????????J5PYJ????5YJJJJ?JG55YY
JJ?J??JPP5JJ???JJJJJJJ????YGBBBBBBBBBB#B5PPYJ??JJJ???????JJJYY5P5YJJ?????????YYJJYPPYJ??JJ???J5P5555
JYYYYYYY5GP555YJJJJJJJYY5GBBBBBBBBBBB#BPYJ????JJ??????????????JJJJY555YJ?????5YJJJJJJ5GYYYY5PP5YYYYY
!!!!7777!!7J5Y?JBBBBBB###BBBBBBBBBB#G5J??J???J?JJJJJJJJJJJJ??J???JYYJJ5PPPYY??JJ???JYPP55555YYYYYYYY
!!!!!!!7??J?7!!7#BBBB#BBBBBBBBBB#BPYJ??JJJJJY5555PPPPPPP5PPPYJJJJYYJJYYJJG5PP55YY55P55YYYYYYYYYYYYYY
!!!!!!!77!!!!!!?#BBBBBBBBBBBB##B5J???JJJJYPGBGP555555PPGGGGGBP5YYYYYYYYYPPYYY555555YYYYYYYYYYYYYYYYY
!!!!!!!77!!!!!!?#BBBBBBBBBBBB##B5J???JJJJYPGBGP555555PPGGGGGBP5YYYYYYYYYPPYYY555555YYYYYYYYYYYYYYYYY
EOF

filename=$1
shift

show_help() {
    cat << EOF

Pokemon Usage Analysis Tool
Usage: ./script.sh <file.csv> [OPTIONS]

Options:
  -h, --help          Show this help screen
  -i, --info          Display highest adjusted and raw usage
  -s, --sort <col>    Sort by column (name, usage, raw, hp, atk, def, spatk, spdef, speed)
  -g, --grep <name>   Search for a specific Pokemon by name
  -f, --filter <type> Filter Pokemon by type

Examples:
  ./script.sh pokemon_usage.csv --info
  ./script.sh pokemon_usage.csv --sort usage
  ./script.sh pokemon_usage.csv --grep Pikachu
  ./script.sh pokemon_usage.csv --filter Electric
EOF
}

if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided. Use -h or --help for more information."
    exit 1
fi

info() {
    echo "Displaying highest adjusted and raw usage..."
}

sortalpha() {
    if [ -z "$1" ]; then
        echo "Error: No sorting column provided. Use -h or --help."
        exit 1
    fi
    echo "Sorting by column: $1"
}

search_pokemon() {
    if [ -z "$1" ]; then
        echo "Error: No Pokemon name provided. Use -h or --help."
        exit 1
    fi
    echo "Searching for Pokemon: $1"
}

filter() {
    if [ -z "$1" ]; then
        echo "Error: No filter option provided. Use -h or --help."
        exit 1
    fi
    echo "Filtering by type: $1"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -i|--info)
            info
            ;;
        -s|--sort)
            shift
            sortalpha "$1"
            ;;
        -g|--grep)
            shift
            search_pokemon "$1"
            ;;
        -f|--filter)
            shift
            filter "$1"
            ;;
        *)
            echo "Unknown Argument: $1"
            echo "Use -h or --help for more information."
            exit 1
            ;;
    esac
    shift
}
```
