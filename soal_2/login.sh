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
