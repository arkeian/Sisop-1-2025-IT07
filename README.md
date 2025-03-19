
## anggota

| Nama | NRP |
|------|------|
|      |      |
|Mochkamad maulana syafaat|5027241021|
|       |      |





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
