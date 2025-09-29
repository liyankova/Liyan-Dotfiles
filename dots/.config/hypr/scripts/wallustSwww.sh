#!/bin/bash
# ╭──────────────────────────────────────────────────╮
# │  Wallust: Update theme from wallpaper            │
# │                                                  │
# │  Maintained by @liyankova                        │
# ╰──────────────────────────────────────────────────╯

set -euo pipefail

# Accept a wallpaper path as an optional first argument
passed_path="${1:-}"
cache_dir="$HOME/.cache/swww/"
rofi_link="$HOME/.config/rofi/.current_wallpaper"

get_focused_monitor() {
    if command -v jq >/dev/null 2>&1; then
        hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
    else
        hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}'
    fi
}

wallpaper_path=""
if [[ -n "$passed_path" && -f "$passed_path" ]]; then
    wallpaper_path="$passed_path"
else
    current_monitor="$(get_focused_monitor)"
    cache_file="$cache_dir$current_monitor"

    # Fallback to cache if no path is passed
    if [[ -f "$cache_file" ]]; then
        wallpaper_path="$(grep -v 'Lanczos3' "$cache_file" | head -n 1)"
    fi
fi

if [[ -z "${wallpaper_path:-}" || ! -f "$wallpaper_path" ]]; then
    # Exit silently if no wallpaper path can be determined
    exit 0
fi

# Create symlink for Rofi
ln -sf "$wallpaper_path" "$rofi_link" || true

# Run wallust silently to update all templates
wallust run -s "$wallpaper_path" || true
