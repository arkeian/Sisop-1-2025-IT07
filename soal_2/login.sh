#!/bin/bash

DB_FILE="/home/maulana/data/player.csv"
SALT="arcane_salt"

read -p "Masukkan email: " email
read -p "Masukkan password: " password

if ! grep -q "^$email," "$DB_FILE"; then
    echo "Login gagal! Email tidak ditemukan."
    exit 1
fi
stored_hash=$(grep "^$email," "$DB_FILE" | cut -d',' -f3)
hashed_password=$(echo -n "$password$SALT" | sha256sum | awk '{print $1}')
if [ "$hashed_password" = "$stored_hash" ]; then
    echo "Login berhasil! Selamat datang, $(grep "^$email," "$DB_FILE" | cut -d',' -f2)"
else
    echo "Login gagal! Password salah."
    exit 1
fi
