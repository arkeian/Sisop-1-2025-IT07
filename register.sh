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

