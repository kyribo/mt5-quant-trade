#!/bin/bash
# 06_install_python_libs.sh
set -e

echo "========================================================================"
echo "Tahap 6: Eksekusi Pemasangan Pustaka Pihak Ketiga Python (Pip)..."
echo "========================================================================"

PYTHON_EXE='wine "C:\Python\python.exe"'

echo "--> Menginstal modul konektor MetaTrader5..."
eval $PYTHON_EXE -m pip install MetaTrader5

echo "--> Menginstal modul pendukung Database PostgreSQL (SQLAlchemy & psycopg2)..."
eval $PYTHON_EXE -m pip install SQLAlchemy psycopg2-binary

echo "Seluruh pustaka Python telah sukses terinstal."
