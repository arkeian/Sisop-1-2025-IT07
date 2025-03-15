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
