#!/bin/bash

#-----------------------------------------------------
# A script to select and apply a theme for Hyprland using wofi.
#
# REQUIRED:
# 1. wofi:   For the selection menu.
# 2. swww:   For managing wallpapers (https://github.com/Horus645/swww).
# 3. Waybar: The status bar.
# 4. Wlogout: Logout menu
#-----------------------------------------------------

#-----------#
# VARIABLES #
#-----------#

# State file to track the current theme
STATE_FILE="$HOME/.cache/theme_state"

# --- Theme 1: Gruvbox ---
gruvbox_wallpaper="$HOME/.config/hypr/wallpapers/sushi.jpg"
gruvbox_waybar_dir="$HOME/.config/waybar/themes/gruvbox"
gruvbox_wofi_style="$HOME/.config/wofi/themes/gruvbox/style.css"
gruvbox_wlogout_style="$HOME/.config/wlogout/themes/gruvbox/style.css"

# --- Theme 2: Red ---
red_wallpaper="$HOME/.config/hypr/wallpapers/red.jpg"
red_waybar_dir="$HOME/.config/waybar/themes/red"
red_wofi_style="$HOME/.config/wofi/themes/red/style.css"
red_wlogout_style="$HOME/.config/wlogout/themes/red/style.css"

# --- Theme 3: Windows ---
windows_wallpaper="$HOME/.config/hypr/wallpapers/windows.jpg"
windows_waybar_dir="$HOME/.config/waybar/themes/windows"
windows_wofi_style="$HOME/.config/wofi/themes/windows/style.css"
windows_wlogout_style="$HOME/.config/wlogout/themes/windows/style.css"

# --- Target Symlinks ---
# Waybar will always look for its config and style in this location.
# We will change where these links point to.
waybar_config_link="$HOME/.config/waybar/config"
waybar_style_link="$HOME/.config/waybar/style.css"
current_wallpaper_link="$HOME/.config/hypr/wallpapers/current.jpg"
wofi_style_link="$HOME/.config/wofi/style.css"
wlogout_style_link="$HOME/.config/wlogout/style.css"

#-----------#
# FUNCTIONS #
#-----------#

# Function to apply a theme (This function is unchanged)
apply_theme() {
    local theme_name=$1
    local wallpaper=$2
    local waybar_dir=$3
    local wofi_style=$4
    local wlogout_style=$5

    echo "Applying $theme_name theme..."

    # 1. Set the wallpaper
    # Make sure swww is running
    if ! pgrep -x "swww-daemon" > /dev/null; then
        swww-daemon &
        sleep 0.5 # Give it a moment to start
    fi
    swww img "$wallpaper" --transition-type wipe --transition-angle 30 --transition-step 90

    # 2. Update configs and styles
    # Remove old symlinks
    rm -f "$waybar_config_link" "$waybar_style_link" "$current_wallpaper_link" "$wofi_style_link" "$wlogout_style_link"

    # Create new symlinks
    ln -s "$waybar_dir/config.jsonc" "$waybar_config_link"
    ln -s "$waybar_dir/style.css" "$waybar_style_link"
    ln -s "$wallpaper" "$current_wallpaper_link"
    ln -s "$wofi_style" "$wofi_style_link"
    ln -s "$wlogout_style" "$wlogout_style_link"

    # 3. Reload Waybar to apply changes
    killall -q waybar
    while pgrep -u $UID -x waybar >/dev/null; do sleep 0.1; done
    waybar &

    # 4. Update the state file
    echo "$theme_name" > "$STATE_FILE"

    echo "$theme_name theme applied successfully!"
}


#-------------------------------------------#
#                  MAIN                     #
#-------------------------------------------#

# Create a newline-separated list of theme names
THEME_LIST="Gruvbox\nRed\nWindows"

# Use wofi to present the theme list and capture the user's choice
selected_theme=$(echo -e "$THEME_LIST" | wofi --dmenu -p "Select Theme")

# Exit if the user cancels (selection is empty)
if [ -z "$selected_theme" ]; then
    echo "No theme selected. Exiting."
    exit 0
fi

# Apply the theme based on the user's selection
case "$selected_theme" in
    "Gruvbox")
        apply_theme "gruvbox" "$gruvbox_wallpaper" "$gruvbox_waybar_dir" "$gruvbox_wofi_style" "$gruvbox_wlogout_style"
        ;;
    "Red")
        apply_theme "red" "$red_wallpaper" "$red_waybar_dir" "$red_wofi_style" "$red_wlogout_style"
        ;;
    "Windows")
        apply_theme "windows" "$windows_wallpaper" "$windows_waybar_dir" "$windows_wofi_style" "$windows_wlogout_style"
        ;;
    *)
        echo "Error: Invalid theme selected."
        exit 1
        ;;
esac

exit 0
