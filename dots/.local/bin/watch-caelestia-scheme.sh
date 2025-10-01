#!/bin/bash

SCHEME_FILE="$HOME/.local/state/caelestia/scheme.json"
UPDATE_SCRIPT="$HOME/.local/bin/update-omp-theme.sh"

# Loop selamanya, awasi event 'close_write' yang menandakan file selesai ditulis/diubah
while inotifywait -e close_write "$SCHEME_FILE"; do
    echo "scheme.json berubah, menjalankan update-omp-theme.sh..."
    # Jalankan skrip update OMP theme
    bash "$UPDATE_SCRIPT"
done
