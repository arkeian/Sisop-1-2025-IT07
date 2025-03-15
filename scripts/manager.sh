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
