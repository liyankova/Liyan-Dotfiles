#!/bin/bash
# ╭──────────────────────────────────────────────────╮
# │  Animation Style Selector                        │
# │  Uses Rofi to switch between animation presets.  │
# │                                                  │
# │  Maintained by @liyankova                        │
# ╰──────────────────────────────────────────────────╯

# Directories
ANIM_DIR="$HOME/.config/hypr/animations"
CONFIG_DIR="$HOME/.config/hypr/configs"
ROFI_CONFIG="$HOME/.config/rofi/config-short.rasi" # A minimal Rofi config might be needed

# Target symlink
TARGET_LINK="$CONFIG_DIR/animations.conf"

# Get current style
current_style=$(readlink -f "$TARGET_LINK" | xargs basename)

# Rofi menu
rofi_cmd() {
    rofi -dmenu \
        -i \
        -p "animations" \
        -config "$ROFI_CONFIG"
}

# List animation styles
list_styles() {
    ls -1 "$ANIM_DIR" | while read -r style; do
        if [ "$style" == "$current_style" ]; then
            # Mark the current style
            echo -e "$style\0meta\x1f<b>  Current</b>"
        else
            echo "$style"
        fi
    done
}

# Main function
main() {
    choice=$(list_styles | rofi_cmd)

    if [ -n "$choice" ]; then
        chosen_file="$ANIM_DIR/$choice"
        if [ -f "$chosen_file" ]; then
            # Create/update symlink
            ln -sf "$chosen_file" "$TARGET_LINK"
            notify-send "animations" "Animation style set to: $choice"
        else
            notify-send -u critical "Animation Error" "File '$chosen_file' not found."
        fi
    fi
}

main
