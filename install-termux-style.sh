#!/data/data/com.termux/files/usr/bin/bash

# =============================
# Termux Style + Music Installer
# =============================

clear
echo -e "\033[1;32m"
echo "=================================="
echo "   Termux Style + Music Installer"
echo "=================================="
echo -e "\033[0m"

# --- Input nama ---
read -p "Masukkan nama yang akan dipakai di prompt: " USERNAME
if [ -z "$USERNAME" ]; then
    echo "Nama tidak boleh kosong! Menggunakan default: user"
    USERNAME="user"
fi

# --- Animasi loading ---
loading() {
    local msg="$1"
    echo -n "$msg "
    for i in {1..3}; do
        echo -n "."
        sleep 0.4
    done
    echo ""
}

# --- Install paket ---
loading "Menginstall paket yang dibutuhkan"
pkg install -y figlet sox > /dev/null 2>&1
pkg install -y ruby > /dev/null 2>&1 && gem install lolcat > /dev/null 2>&1

# --- Siapkan musik ---
MUSIC_FILE="$HOME/startup.mp3"
if [ ! -f "$MUSIC_FILE" ]; then
    echo "[*] Menyalin musik bawaan..."
    cp ~/husarski-cyberwave-172902.mp3 "$MUSIC_FILE" 2>/dev/null || touch "$MUSIC_FILE"
fi

# --- Update .bashrc ---
BASHRC="$HOME/.bashrc"

# Hapus konfigurasi lama jika ada
sed -i '/# START TERMUX STYLE/,/# END TERMUX STYLE/d' "$BASHRC"

cat <<EOL >> "$BASHRC"
# START TERMUX STYLE
trap 'pkill -f "play \$HOME/startup.mp3" > /dev/null 2>&1' EXIT
play \$HOME/startup.mp3 gain 3 repeat 999 > /dev/null 2>&1 &
clear
if command -v lolcat > /dev/null 2>&1; then
    figlet "Welcome" | lolcat
else
    figlet "Welcome"
fi
PS1="~ ☠️${USERNAME}☠️ "
# END TERMUX STYLE
EOL

clear
echo -e "\033[1;32mSelesai!\033[0m"
echo "Tutup dan buka ulang Termux untuk melihat perubahan."
