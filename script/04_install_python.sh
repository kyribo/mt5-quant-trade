#!/bin/bash
# 04_install_python.sh
set -e

echo "Tahap 4: Mengunduh dan Menyiapkan Python 3.11 Windows (Embeddable Zip) untuk Wine..."

# Penentuan Versi & Path Absolut C:\Python
PYTHON_ZIP_URL="https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip"
PYTHON_DIR="/root/.wine/drive_c/Python"
# Path absolut executable python milik Wine-Windows dalam terminologi path Linux:
WINE_PYTHON_EXE="C:\\Python\\python.exe"

echo "[1] Mengunduh Python 3.11 Windows (Embeddable Zip) ke direktori Root..."
mkdir -p "$PYTHON_DIR"
apt-get update -y && apt-get install -y unzip curl
wget -O /root/python.zip "$PYTHON_ZIP_URL"

echo "[1.5] Mengunduh skrip get-pip.py..."
wget -O /root/get-pip.py "https://bootstrap.pypa.io/get-pip.py"

echo "[2] Mempersiapkan Integrasi Terminal Linux (Bash Alias)..."
# Mewajibkan bash linux untuk memanggil python HANYA melalui path absolut "C:\Python\python.exe"
echo "alias wpython='WINEDLLOVERRIDES=\"ucrtbase=n,b\" wine \"C:\\Python\\python.exe\"'" >> /root/.bash_aliases
# Menambahkan pemuatan aliases
echo "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi" >> /root/.bashrc

echo "cd /workspace || true" >> /root/.bashrc
echo "echo '***************************************************'" >> /root/.bashrc
echo "echo '* Selamat datang di Terminal MT5 Docker !         *'" >> /root/.bashrc
echo "echo '* Direktori kerja saat ini berada di /workspace   *'" >> /root/.bashrc
echo "echo '* Gunakan syntax berikut: wpython skrip_anda.py   *'" >> /root/.bashrc
echo "echo '***************************************************'" >> /root/.bashrc

echo "Tahap 4 Selesai! File Python Installer telah diunduh di /root/python-installer.exe. Eksekusi akan ditangani secara tersembunyi oleh 05_start.sh."
