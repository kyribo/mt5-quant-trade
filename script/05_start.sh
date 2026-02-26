#!/bin/bash
# 04_start.sh
set -e

# Mengambil konfigurasi dari environment variables (.env jika ada)
VNC_PORT=${VNC_PORT:-8444}
VNC_USER=${VNC_USER:-admin}
VNC_PASSWORD=${VNC_PASSWORD:-password}

echo "Mengonfigurasi password KasmVNC untuk user: $VNC_USER"
mkdir -p /root/.kasminc /root/.vnc

# Membuat sertifikat SSL jika belum ada
if [ ! -f /etc/ssl/certs/kasmvnc.pem ]; then
    echo "Membuat sertifikat SSL Mandiri..."
    make-ssl-cert generate-default-snakeoil --force-overwrite
    cp /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/kasmvnc.pem
    cp /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/kasmvnc.key
    chmod 644 /etc/ssl/certs/kasmvnc.pem
    chmod 640 /etc/ssl/private/kasmvnc.key
fi

# Set kredensial VNC
echo -e "${VNC_PASSWORD}\n${VNC_PASSWORD}\n" | vncpasswd -u ${VNC_USER} -rw

# Setup Desktop Environment Startup (Single Application Mode: Openbox)
cat << 'EOF' > /root/.vnc/xstartup
#!/bin/sh
xrdb $HOME/.Xresources
# Menjalankan window manager super ringan (agar jendela bisa digeser/resize)
openbox &

# Menjalankan terminal bawaan XFCE
xfce4-terminal &

# Menjalankan MetaTrader 5 jika flag instalasi telah siap (Cegah deadlock)
(
  while [ ! -f "/tmp/mt5_ready" ]; do
      sleep 2
  done
  wine64 "C:\Program Files\MetaTrader 5\terminal64.exe"
) &
EOF
chmod +x /root/.vnc/xstartup

# Injeksi Keyboard Shortcut "Ctrl+Alt+T" pada Openbox
mkdir -p /root/.config/openbox
cat << 'EOF' > /root/.config/openbox/rc.xml
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc" xmlns:xi="http://www.w3.org/2001/XInclude">
  <keyboard>
    <keybind key="C-A-t">
      <action name="Execute">
        <command>xfce4-terminal</command>
      </action>
    </keybind>
  </keyboard>
</openbox_config>
EOF

# Mencegah munculnya prompt interaktif seleksi Desktop Environment
export KASMVNC_AUTO_START=1
export DESKTOP_SESSION=openbox

# Mematikan script paksa dari KasmVNC yang menagih prompt
mkdir -p /usr/lib/kasmvncserver/
echo "exit 0" > /usr/lib/kasmvncserver/select-de.sh
chmod +x /usr/lib/kasmvncserver/select-de.sh

# Konfigurasi Auto-Scale (Dynamic/True Resolution) & Network KasmVNC
mkdir -p /etc/kasmvnc
cat << 'EOF' > /etc/kasmvnc/kasmvnc.yaml
network:
  use_ipv4: true
  use_ipv6: true
EOF
rm -f /root/.vnc/kasmvnc.yaml

# Membersihkan lock X-Server sisa restart KasmVNC
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

echo "Memulai Server KasmVNC pada port 8444..."
vncserver :1 -interface 0.0.0.0 -FrameRate 24 -port 8444 -geometry 1280x720 -depth 24
sleep 5

# Set environment tampilan ke display yang dibuat KasmVNC
export DISPLAY=:1
export WINEARCH=win64
export WINEPREFIX=/root/.wine

if [ -f "/root/mt5setup.exe" ]; then
    echo "Inisialisasi lingkungan Wine terlebih dahulu (Bypass Mono/Gecko)..."
    WINEDLLOVERRIDES="mscoree,mshtml=" wineboot --init
    wineserver -k
    
    echo "Menjalankan instalasi MT5 via GUI... (anda bisa melihatnya di browser)"
    wine /root/mt5setup.exe /auto || true
    wineserver -k
    rm -f /root/mt5setup.exe
fi

PYTHON_DIR="/root/.wine/drive_c/Python"
if [ ! -f "$PYTHON_DIR/python.exe" ] && [ -f "/root/python.zip" ]; then
    echo "========================================================================"
    echo "Sinkronisasi Volume Tertunda: Mengekstrak Python 3.11 Embeddable..."
    echo "========================================================================"
    
    echo "--> Membuka arsip python.zip ke direktori Wine C:\Python..."
    unzip -q /root/python.zip -d "$PYTHON_DIR"
    
    echo "--> Memodifikasi python311._pth agar mendukung instalasi module (pip)..."
    # Menghilangkan tanda komentar pada '#import site' di konfigurasi Python Portable
    sed -i 's/#import site/import site/g' "$PYTHON_DIR/python311._pth"
    
    echo "--> Menginisialisasi PIP Package Manager untuk pertama kalinya..."
    # Memanggil installer PIP mandiri menggunakan Python yang baru diekstrak
    WINEDLLOVERRIDES="ucrtbase=n,b" wine "$PYTHON_DIR/python.exe" /root/get-pip.py
    
    # Wine terkadang tidak mulus memasukkan Path Instalasi Python saat Instalasi EXE C:
    # Memastikan UCRT/Python tertancap kuat
    wine reg add "HKCU\Environment" /v PATH /t REG_SZ /d "C:\Python;C:\Python\Scripts;%PATH%" /f
    wineserver -k
    
    echo "--> Menjalankan instalasi kolektif pustaka Python eksternal (Metatrader5, SQLAlchemy, dll)..."
    bash /setup/script/06_install_python_libs.sh
    wineserver -k
    
    echo "--> Meregistrasikan folder C:\Python dan C:\Python\Scripts ke Environment Variables PATH Wine..."
    wine reg add "HKCU\Environment" /v PATH /t REG_SZ /d "C:\Python;C:\Python\Scripts;%PATH%" /f
    wineserver -k
    echo "Setup Python Selesai!"
fi

echo "Server VNC berjalan. Akses melalui browser di https://localhost:${VNC_PORT}"

# Membuka gerbang bagi xstartup untuk mulai menampilkan jendela MT5
echo "Membuat penanda MT5 Ready untuk VNC Display..."
touch /tmp/mt5_ready

echo "Mengamankan container agar tetap berjalan (Tail null)..."
tail -f /dev/null
