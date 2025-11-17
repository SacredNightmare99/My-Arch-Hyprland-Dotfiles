#!/bin/bash

# -------------------------------------------------
# Theme switcher: applies theme + last-used wallpaper
# -------------------------------------------------

THEME_STATE_FILE="$HOME/.cache/theme_state"
WALL_STATE_PREFIX="$HOME/.cache/wallpaper_state_"

# Theme resources

# Gruvbox
gruvbox_wallpaper_dir="$HOME/.config/hypr/wallpapers/gruvbox"
gruvbox_waybar_dir="$HOME/.config/waybar/themes/gruvbox"
gruvbox_wofi_style="$HOME/.config/wofi/themes/gruvbox/style.css"
gruvbox_wlogout_style="$HOME/.config/wlogout/themes/gruvbox/style.css"

# Red
red_wallpaper_dir="$HOME/.config/hypr/wallpapers/red"
red_waybar_dir="$HOME/.config/waybar/themes/red"
red_wofi_style="$HOME/.config/wofi/themes/red/style.css"
red_wlogout_style="$HOME/.config/wlogout/themes/red/style.css"

# Blue
blue_wallpaper_dir="$HOME/.config/hypr/wallpapers/blue"
blue_waybar_dir="$HOME/.config/waybar/themes/blue"
blue_wofi_style="$HOME/.config/wofi/themes/blue/style.css"
blue_wlogout_style="$HOME/.config/wlogout/themes/blue/style.css"

# Windows
windows_wallpaper_dir="$HOME/.config/hypr/wallpapers/windows"
windows_waybar_dir="$HOME/.config/waybar/themes/windows"
windows_wofi_style="$HOME/.config/wofi/themes/windows/style.css"
windows_wlogout_style="$HOME/.config/wlogout/themes/windows/style.css"

# Target symlinks
waybar_config_link="$HOME/.config/waybar/config"
waybar_style_link="$HOME/.config/waybar/style.css"
current_wallpaper_link="$HOME/.config/hypr/wallpapers/current.jpg"
wofi_style_link="$HOME/.config/wofi/style.css"
wlogout_style_link="$HOME/.config/wlogout/style.css"



# ----------------------
# Helper: pick wallpaper
# ----------------------
choose_wallpaper_for_theme() {
    local theme_name="$1"
    local dir="$2"
    local state_file="${WALL_STATE_PREFIX}${theme_name}"

    # 1. Try last-used wallpaper if it still exists
    if [ -f "$state_file" ]; then
        local saved_wallpaper
        saved_wallpaper="$(cat "$state_file")"
        if [ -n "$saved_wallpaper" ] && [ -f "$saved_wallpaper" ]; then
            echo "$saved_wallpaper"
            return 0
        fi
    fi

    # 2. Fallback to first image in theme directory
    if [ ! -d "$dir" ]; then
        echo ""
        return 1
    fi

    local first_wallpaper
    first_wallpaper="$(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | sort | head -n1)"

    echo "$first_wallpaper"
}



# ----------------------
# Core: apply theme
# ----------------------
apply_theme() {
    local theme_name="$1"
    local wallpaper_dir="$2"
    local waybar_dir="$3"
    local wofi_style="$4"
    local wlogout_style="$5"

    local wallpaper
    wallpaper="$(choose_wallpaper_for_theme "$theme_name" "$wallpaper_dir")"

    if [ -z "$wallpaper" ]; then
        echo "No wallpapers found for theme '$theme_name' in '$wallpaper_dir'."
        exit 1
    fi

    # Ensure swww-daemon is running
    if ! pgrep -x "swww-daemon" >/dev/null; then
        swww-daemon &
        sleep 0.4
    fi

    # Apply wallpaper
    swww img "$wallpaper" --transition-type wipe --transition-angle 30 --transition-step 90

    # Update symlinks
    rm -f "$waybar_config_link" "$waybar_style_link" "$current_wallpaper_link" "$wofi_style_link" "$wlogout_style_link"

    ln -s "$waybar_dir/config.jsonc" "$waybar_config_link"
    ln -s "$waybar_dir/style.css" "$waybar_style_link"
    ln -s "$wallpaper" "$current_wallpaper_link"
    ln -s "$wofi_style" "$wofi_style_link"
    ln -s "$wlogout_style" "$wlogout_style_link"

    # Reload waybar
    killall -q waybar
    while pgrep -u "$UID" -x waybar >/dev/null; do sleep 0.1; done
    waybar &

    # Save theme + wallpaper state
    echo "$theme_name" > "$THEME_STATE_FILE"
    echo "$wallpaper" > "${WALL_STATE_PREFIX}${theme_name}"
}



# ----------------------
# Menu
# ----------------------
THEME_LIST="Gruvbox\nRed\nBlue\nWindows"

selected_theme=$(echo -e "$THEME_LIST" | wofi --dmenu -p "Select Theme")

[ -z "$selected_theme" ] && exit 0

case "$selected_theme" in
    "Gruvbox")
        apply_theme "gruvbox" "$gruvbox_wallpaper_dir" "$gruvbox_waybar_dir" "$gruvbox_wofi_style" "$gruvbox_wlogout_style"
        ;;
    "Red")
        apply_theme "red" "$red_wallpaper_dir" "$red_waybar_dir" "$red_wofi_style" "$red_wlogout_style"
        ;;
    "Blue")
        apply_theme "blue" "$blue_wallpaper_dir" "$blue_waybar_dir" "$blue_wofi_style" "$blue_wlogout_style"
        ;;
    "Windows")
        apply_theme "windows" "$windows_wallpaper_dir" "$windows_waybar_dir" "$windows_wofi_style" "$windows_wlogout_style"
        ;;
esac

