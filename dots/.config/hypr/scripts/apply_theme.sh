#!/usr/bin/env bash

# Keluar dari skrip jika ada error
set -e

THEME_JSON="$HOME/.local/state/caelestia/scheme.json"
HYPR_COLORS="$HOME/.config/hypr/colors.conf"

if [ ! -f "$THEME_JSON" ]; then
    echo "File scheme.json tidak ditemukan!"
    exit 1
fi

# Beri jeda sedikit agar Caelestia selesai menulis file JSON
sleep 1.0

active_border_hex=$(jq -r '.colours.primary' "$THEME_JSON")
inactive_border_hex=$(jq -r '.colours.outline' "$THEME_JSON")

if [ -z "$active_border_hex" ] || [ "$active_border_hex" == "null" ]; then
    echo "Gagal mengambil warna 'primary' dari scheme.json"
    exit 1
fi

cat > "$HYPR_COLORS" << EOF
# --- Warna Tema Otomatis dari Caelestia --- #
# File ini dibuat otomatis oleh apply_theme.sh

\$active_border_col = rgb($active_border_hex)
\$inactive_border_col = rgb($inactive_border_hex)
EOF

# RELOAD HYPRLAND SETELAH WARNA DIPERBARUI
hyprctl reload

notify-send "Hyprland Theme" "Tema border berhasil diperbarui!" -i "dialog-information"
