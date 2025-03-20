# Laporan Resmi Modul 1
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
b.Sistem login/register Email harus memiliki format yang benar dengan tanda @ dan titik, sementara password harus memiliki minimal 8 karakter, setidaknya satu huruf kecil, satu huruf besar, dan satu angka 

```sh
if [[ "$email" != *@*.* ]]; then
```

```sh
if [[ ! "$password" =~ [A-Z] || ! "$password" =~ [a-z] || ! "$password" =~ [0-9] || ${#password} -lt 8 ]]; then
```

c.Karena diperlukan pengecekan keaslian “Player” yang aktif, maka diperlukan sistem untuk pencegahan duplikasi “Player”. Jadikan sistem login/register tidak bisa memakai email yang sama (email = unique), tetapi tidak ada pengecekan tambahan untuk username.

```sh
if grep -q "^$email," "$DB_FILE"; then
    echo "Email sudah terdaftar!"
    exit 1
fi
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


