#!/bin/bash
# ╭──────────────────────────────────────────────────╮
# │  Set Wallpaper per Workspace                     │
# │  Changes wallpaper and theme based on workspace. │
# │                                                  │
# │  Maintained by @liyankova                        │
# ╰──────────────────────────────────────────────────╯


# --- VARIABLES ---
WALLPAPER_DIR="$HOME/Pictures/wallpapers/workspace/"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
SWWW_PARAMS="--transition-type wipe --transition-angle 30 --transition-step 90"

# Find a wallpaper matching the workspace number (e.g., 1.png, 1.jpg)
WALLPAPER_PATH=$(find "$WALLPAPER_DIR" | head -n 1)

if [ -n "$WALLPAPER_PATH" ]; then
    # 1. Set the new wallpaper
    swww img "$WALLPAPER_PATH" $SWWW_PARAMS

    # 2. Update theme using the new robust method (passing the path explicitly)
    "$SCRIPTS_DIR/wallustSwww.sh" "$WALLPAPER_PATH"
    
    # Give Wallust a moment to write the new theme files
    sleep 0.5

    # 3. Apply the new theme to running applications
    "$SCRIPTS_DIR/refresh.sh"
    
    sleep 0.2

fi
