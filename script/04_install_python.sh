#!/bin/bash
# 04_install_python.sh
set -e

echo "Tahap 4: Mengunduh dan Menyiapkan Python 3.11 Windows (Embeddable Zip) untuk Wine..."

# Penentuan Versi & Path Absolut C:\Python
PYTHON_EXE_URL="https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe"
PYTHON_DIR="/root/.wine/drive_c/Python"
# Path absolut executable python milik Wine-Windows dalam terminologi path Linux:
WINE_PYTHON_EXE="C:\\Python\\python.exe"

echo "[1] Mengunduh Installer Resmi Python 3.11 EXE ke direktori Root..."
mkdir -p "$PYTHON_DIR"
apt-get update -y && apt-get install -y unzip curl
wget -O /root/python-installer.exe "$PYTHON_EXE_URL"

echo "[1.5] Mengunduh Microsoft Visual C++ Redistributable 2015-2022..."
wget -O /root/vc_redist.x64.exe "https://aka.ms/vs/17/release/vc_redist.x64.exe"

echo "[2] Mempersiapkan Integrasi Terminal Linux (Bash Alias)..."
# Mewajibkan bash linux untuk memanggil python HANYA melalui path absolut "C:\Python\python.exe"
echo "alias wpython='wine \"C:\\Python\\python.exe\"'" >> /root/.bash_aliases
# Menambahkan pemuatan aliases
echo "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi" >> /root/.bashrc

echo "echo '***************************************************'" >> /root/.bashrc
echo "echo '* Selamat datang di Terminal MT5 Docker !         *'" >> /root/.bashrc
echo "echo '* Gunakan syntax berikut: wpython skrip_anda.py   *'" >> /root/.bashrc
echo "echo '* Ini akan mengeksekusi C:\Python\python.exe Wine *'" >> /root/.bashrc
echo "echo '***************************************************'" >> /root/.bashrc

echo "Tahap 4 Selesai! File Python Installer telah diunduh di /root/python-installer.exe. Eksekusi akan ditangani secara tersembunyi oleh 05_start.sh."
