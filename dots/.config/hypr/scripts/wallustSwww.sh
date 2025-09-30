#!/bin/bash
#
# # ╭──────────────────────────────────────────────────╮
# # │  Wallust: Update theme from wallpaper            │
# # │  Source: JaKooLit's development branch           │
# # │                                                  │
# # │  Maintained by @liyankova                        │
# # ╰──────────────────────────────────────────────────╯
# set -euo pipefail
#
# # Accept a wallpaper path as an optional first argument
# passed_path="${1:-}"
# cache_dir="$HOME/.cache/swww/"
# rofi_link="$HOME/.config/rofi/.current_wallpaper"
#
# get_focused_monitor() {
#     if command -v jq >/dev/null 2>&1; then
#         hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
#     else
#         hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}'
#     fi
# }
#
# wallpaper_path=""
# if [[ -n "$passed_path" && -f "$passed_path" ]]; then
#     wallpaper_path="$passed_path"
# else
#     current_monitor="$(get_focused_monitor)"
#     cache_file="$cache_dir$current_monitor"
#
#     # Fallback to cache if no path is passed
#     if [[ -f "$cache_file" ]]; then
#         wallpaper_path="$(grep -v 'Lanczos3' "$cache_file" | head -n 1)"
#     fi
# fi
#
# if [[ -z "${wallpaper_path:-}" || ! -f "$wallpaper_path" ]]; then
#     # Exit silently if no wallpaper path can be determined
#     exit 0
# fi
#
# # Create symlink for Rofi
# ln -sf "$wallpaper_path" "$rofi_link" || true
#
# # Run wallust silently to update all templates
# wallust run -s "$wallpaper_path" || true

# #!/bin/bash
# Wallust: Update theme from wallpaper
# Maintained by @liyankova
#
# set -euo pipefail
#
# passed_path="${1:-}"
# cache_dir="$HOME/.cache/swww/"
# rofi_link="$HOME/.config/rofi/.current_wallpaper"
# wallust_json="$HOME/.config/wallust/wallust.json"
# scheme_json="$HOME/.local/state/caelestia/scheme.json"
#
# get_focused_monitor() {
#     if command -v jq >/dev/null 2>&1; then
#         hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
#     else
#         hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}'
#     fi
# }
#
# wallpaper_path=""
# if [[ -n "$passed_path" && -f "$passed_path" ]]; then
#     wallpaper_path="$passed_path"
# else
#     current_monitor="$(get_focused_monitor)"
#     cache_file="$cache_dir$current_monitor"
#     if [[ -f "$cache_file" ]]; then
#         wallpaper_path="$(grep -v 'Lanczos3' "$cache_file" | head -n 1)"
#     fi
# fi
#
# if [[ -z "${wallpaper_path:-}" || ! -f "$wallpaper_path" ]]; then
#     echo "No valid wallpaper path found"
#     exit 1
# fi
#
# # Create symlink for Rofi
# ln -sf "$wallpaper_path" "$rofi_link" || true
#
# # Run Wallust to update templates and generate JSON
# wallust run -s "$wallpaper_path" || true
# wallust json "$wallpaper_path" > "$wallust_json" || true
#
# # Convert Wallust JSON to Caelestia scheme.json format
# jq '{
#     name: "dynamic",
#     flavour: "default",
#     mode: (if .special.background | test("^#[fF][fF].*") then "light" else "dark" end),
#     colours: {
#         m3background: .special.background,
#         m3foreground: .special.foreground,
#         m3primary: .colors.color1,
#         term0: .colors.color0,
#         term1: .colors.color1,
#         term2: .colors.color2,
#         term3: .colors.color3,
#         term4: .colors.color4,
#         term5: .colors.color5,
#         term6: .colors.color6,
#         term7: .colors.color7,
#         term8: .colors.color8,
#         term9: .colors.color9,
#         term10: .colors.color10,
#         term11: .colors.color11,
#         term12: .colors.color12,
#         term13: .colors.color13,
#         term14: .colors.color14,
#         term15: .colors.color15
#     }
# }' "$wallust_json" > "$scheme_json"
#
# # Trigger Caelestia scheme update
# caelestia scheme set -n dynamic


#
# #!/bin/bash
# # ╭──────────────────────────────────────────────────╮
# # │  Wallust: Update theme from wallpaper            │
# # │                                                  │
# # │  Maintained by @liyankova                        │
# # ╰──────────────────────────────────────────────────╯
#
set -euo pipefail

# Inputs and paths
passed_path="${1:-}"
cache_dir="$HOME/.cache/swww/"
rofi_link="$HOME/.config/rofi/.current_wallpaper"
wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

# Helper: get focused monitor name (prefer JSON)
get_focused_monitor() {
  if command -v jq >/dev/null 2>&1; then
    hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
  else
    hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}'
  fi
}

# Determine wallpaper_path
wallpaper_path=""
if [[ -n "$passed_path" && -f "$passed_path" ]]; then
  wallpaper_path="$passed_path"
else
  # Try to read from swww cache for the focused monitor, with a short retry loop
  current_monitor="$(get_focused_monitor)"
  cache_file="$cache_dir$current_monitor"

  # Wait briefly for swww to write its cache after an image change
  for i in {1..10}; do
    if [[ -f "$cache_file" ]]; then
      break
    fi
    sleep 0.1
  done

  if [[ -f "$cache_file" ]]; then
    # The first non-filter line is the original wallpaper path
    wallpaper_path="$(grep -v 'Lanczos3' "$cache_file" | head -n 1)"
  fi
fi

if [[ -z "${wallpaper_path:-}" || ! -f "$wallpaper_path" ]]; then
  # Nothing to do; avoid failing loudly so callers can continue
  exit 0
fi

# Update helpers that depend on the path
ln -sf "$wallpaper_path" "$rofi_link" || true
mkdir -p "$(dirname "$wallpaper_current")"
cp -f "$wallpaper_path" "$wallpaper_current" || true

# Run wallust (silent) to regenerate templates defined in ~/.config/wallust/wallust.toml
# -s is used in this repo to keep things quiet and avoid extra prompts
wallust run -s "$wallpaper_path" || true
