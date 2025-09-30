# ╭──────────────────────────────────────────────────╮
# │  Set Wallpaper per Workspace                     │
# │  Changes wallpaper and theme based on workspace. │
# │                                                  │
# │  Maintained by @liyankova                        │
# ╰──────────────────────────────────────────────────╯
#!/bin/bash

# --- VARIABLES ---
WALLPAPER_DIR="$HOME/Pictures/wallpapers/workspace/"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
SWWW_PARAMS="--transition-type wipe --transition-angle 30 --transition-step 90"

# --- LOGIC ---
WORKSPACE_NUM=$1
if [ -z "$WORKSPACE_NUM" ]; then
    echo "Error: No workspace number provided."
    exit 1
fi

# Find a wallpaper matching the workspace number (e.g., 1.png, 1.jpg)
WALLPAPER_PATH=$(find "$WALLPAPER_DIR" -type f -name "${WORKSPACE_NUM}.*" | head -n 1)

if [ -n "$WALLPAPER_PATH" ]; then
    # 1. Set the new wallpaper
    swww img "$WALLPAPER_PATH" $SWWW_PARAMS

    # 2. Update theme using the new robust method (passing the path explicitly)
    "$SCRIPTS_DIR/wallustSwww.sh" "$WALLPAPER_PATH"
    
    # Give Wallust a moment to write the new theme files
    sleep 0.5

    # 3. Apply the new theme to running applications
    "$SCRIPTS_DIR/refresh.sh"
fi

# The following line is commented out. This script's purpose is to apply a theme,
# not to force a workspace switch.
# hyprctl dispatch workspace "$WORKSPACE_NUM"
#
# # # ╭──────────────────────────────────────────────────╮
# # │  Wallust: Update theme from wallpaper            │
# # │  Source: JaKooLit's development branch           │
# # │                                                  │
# # │  Maintained by @liyankova                        │
# # ╰──────────────────────────────────────────────────╯
# #!/bin/bash
# set -euo pipefail
#
# # Accept a wallpaper path as an optional first argument
# passed_path="${1:-}"
# cache_dir="$HOME/.cache/swww/"
# rofi_link="$HOME/.config/rofi/.current_wallpaper"
#
# # get_focused_monitor() {
# #     if command -v jq >/dev/null 2>&1; then
# #         hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
# #     else
# #         hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}'
# #     fi
# # }
#
# wallpaper_path=""
# if [[ -n "$passed_path" && -f "$passed_path" ]]; then
#     wallpaper_path="$passed_path"
# else
#     # current_monitor="$(get_focused_monitor)"
#     # cache_file="$cache_dir$current_monitor"
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
