#!/bin/bash
# 02_install_kasmvnc.sh
set -e

export DEBIAN_FRONTEND=noninteractive

echo "Tahap 2: Menginstal Window Manager Ringan (Openbox)..."
# Kita mengganti XFCE4 dengan Openbox untuk implementasi Single Application Mode
apt-get install -y openbox xfce4-terminal sudo curl ssl-cert

echo "Mengunduh dan menginstal KasmVNC..."
# Menggunakan build terbaru dari repositori KasmVNC untuk Ubuntu 22.04 (Jammy)
wget -O kasmvnc.deb https://github.com/kasmtech/KasmVNC/releases/download/v1.3.1/kasmvncserver_jammy_1.3.1_amd64.deb
apt-get install -y ./kasmvnc.deb
rm kasmvnc.deb

echo "Mempersiapkan direktori KasmVNC..."
mkdir -p /root/.vnc
mkdir -p /root/.xmonad
