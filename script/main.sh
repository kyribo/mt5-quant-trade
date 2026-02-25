#!/bin/bash
# main.sh
# Skrip utama yang memanggil skrip lain secara berurutan dan menunggu (wait)

set -e

echo "=== MEMULAI PROSES SETUP DOCKER IMAGE ==="

echo "Menjalankan 01_install_wine.sh..."
chmod +x ./01_install_wine.sh
./01_install_wine.sh
wait $!

echo "Menjalankan 02_install_kasmvnc.sh..."
chmod +x ./02_install_kasmvnc.sh
./02_install_kasmvnc.sh
wait $!

echo "Menjalankan 03_install_mt5.sh..."
chmod +x ./03_install_mt5.sh
./03_install_mt5.sh
wait $!

echo "Menjalankan 04_install_python.sh..."
chmod +x ./04_install_python.sh
./04_install_python.sh
wait $!

echo "=== SEMUA PROSES INSTALASI TELAH SELESAI ==="
