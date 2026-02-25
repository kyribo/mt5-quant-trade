#!/bin/bash
# 03_install_mt5.sh
set -e

echo "Tahap 3: Mengunduh Installer MetaTrader 5..."
wget -O /root/mt5setup.exe "https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe"

echo "Installer MT5 disimpan di /root/mt5setup.exe"
# Mengeksekusi secara headless berisiko hang (err:ole RPC) pada docker build.
# Installer akan dieksekusi pada saat container berjalan di 04_start.sh menggunakan DISPLAY KasmVNC.
