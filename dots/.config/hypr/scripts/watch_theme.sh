#!/usr/bin/env bash

# File yang akan dipantau
FILE_TO_WATCH="$HOME/.local/state/caelestia/scheme.json"

# Skrip yang akan dijalankan
SCRIPT_TO_RUN="$HOME/.config/hypr/scripts/apply_theme.sh"

# Loop tak terbatas untuk terus memantau
while true; do
    # inotifywait akan berhenti dan lanjut ke baris berikutnya HANYA jika ada event 'modify' atau 'close_write'
    inotifywait -e modify,close_write --format '%e' "$FILE_TO_WATCH"

    # Jalankan skrip untuk memperbarui warna
    bash "$SCRIPT_TO_RUN"

    # Reload Hyprland agar perubahan warna diterapkan
    hyprctl reload
done
