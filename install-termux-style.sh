#!/data/data/com.termux/files/usr/bin/bash
set -e

# ==== Tampilan awal ====
clear
echo -e "\033[1;36m"
echo "==== Termux Style + Music Installer ===="
echo -e "\033[0m"

# ==== Input nama (wajib) ====
USERNAME=""
while [ -z "$USERNAME" ]; do
  read -p "Masukkan nama untuk prompt: " USERNAME
done

# ==== Cek file musik (wajib ada) ====
MUSIC_FILE="$HOME/husarski-cyberwave-172902.mp3"
if [ ! -f "$MUSIC_FILE" ]; then
  echo "⚠️  File musik tidak ditemukan: $MUSIC_FILE"
  echo "    Letakkan MP3 dengan nama: husarski-cyberwave-172902.mp3 di \$HOME lalu jalankan lagi."
  exit 1
fi

# ==== Loading kecil ====
echo -ne "[+] Menyiapkan dependensi"
for i in 1 2 3 4 5; do echo -n "."; sleep 0.2; done
echo

# ==== Dependensi ====
pkg update -y >/dev/null 2>&1 || true
pkg install -y sox figlet neofetch ruby >/dev/null 2>&1
# lolcat via gem; kalau gagal, nanti fallback ke cat di .bashrc
gem install lolcat --no-document >/dev/null 2>&1 || true

# ==== Backup .bashrc lama (kalau ada) ====
[ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%s)"

# ==== Tulis .bashrc baru ====
cat > "$HOME/.bashrc" <<'EOL'
# ===== Termux Style + Music (auto-generated) =====
USERNAME="__USERNAME__"
MUSIC_FILE="__MUSIC_FILE__"

CYAN="\e[1;36m"; YELLOW="\e[1;33m"; RESET="\e[0m"

start_music() {
  if [ -f "$MUSIC_FILE" ]; then
    # pastikan tidak ada 'play' tersisa
    pkill -9 play >/dev/null 2>&1 || true
    # jalankan musik tanpa output & disown agar tidak munculkan [1]+ Exit ...
    play "$MUSIC_FILE" gain 3 repeat 999 >/dev/null 2>&1 &
    PID_MUSIC=$!
    disown "$PID_MUSIC" 2>/dev/null || true
  fi
}

stop_music() {
  # hentikan musik saat shell keluar
  [ -n "$PID_MUSIC" ] && kill "$PID_MUSIC" >/dev/null 2>&1 || true
  pkill -9 play >/dev/null 2>&1 || true
}

trap stop_music EXIT HUP INT TERM

clear
echo -e "${CYAN}Memulai sistem...${RESET}"
# progress bar sederhana
for i in $(seq 1 28); do
  printf "${YELLOW}%s${RESET}\r" "$(printf '%*s' "$i" '' | tr ' ' '█')"
  sleep 0.03
done
echo
sleep 0.2
clear

# Banner (fallback jika lolcat tak ada)
if command -v lolcat >/dev/null 2>&1; then
  figlet "$USERNAME" | lolcat -a -d 3
else
  figlet "$USERNAME"
fi
echo -e "${CYAN}Tanggal: $(date)${RESET}\n"

# Neofetch jika ada
if command -v neofetch >/dev/null 2>&1; then
  neofetch --ascii_distro kali --colors 6 4 1 8 8 7 8
  echo
fi

# Pesan acak
pesan=("Akses diterima..." "Sistem stabil." "Koneksi aman." "Menunggu perintah...")
echo -e "${YELLOW}${pesan[$RANDOM % ${#pesan[@]}]}${RESET}\n"

# Mulai musik terakhir agar banner tidak patah
start_music

# Prompt rapi
export PS1="~ ☠️${USERNAME}☠️ "
# ===== End =====
EOL

# inject nilai variabel ke .bashrc
sed -i "s|__USERNAME__|$USERNAME|g" "$HOME/.bashrc"
sed -i "s|__MUSIC_FILE__|$MUSIC_FILE|g" "$HOME/.bashrc"

echo "✅ Instalasi selesai. Tutup & buka lagi Termux untuk melihat hasil."
