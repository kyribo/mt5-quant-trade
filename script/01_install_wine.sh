#!/bin/bash
# 01_install_wine.sh
set -e

echo "Tahap 1: Memperbarui sistem dan menginstal dependensi dasar..."
export DEBIAN_FRONTEND=noninteractive
dpkg --add-architecture i386
apt-get update -y
apt-get upgrade -y

echo "Menginstal wget, gnupg2, dan sertifikat..."
apt-get install -y wget gnupg2 software-properties-common apt-transport-https xvfb cabextract

echo "Menginstal direktori Wine dan Mono..."
# Integrasi Repositori Resmi WineHQ Ubuntu 22.04 (Jammy)
mkdir -pm755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources

# Update respositori WineHQ dan Instal Stable (Versi 10.0)
# Peringatan: Wine 11.0 memicu bug 'debugger found' MetaTrader5. Kita memaksa versi 10.0-1 secara spesifik.
apt-get update -y
apt-get install -y --install-recommends winehq-stable=10.0.0.0~jammy-1 wine-stable=10.0.0.0~jammy-1 wine-stable-i386=10.0.0.0~jammy-1 wine-stable-amd64=10.0.0.0~jammy-1 winetricks

echo "Menginstal Mono (untuk dukungan aplikasi .NET)..."
apt-get install -y mono-complete
