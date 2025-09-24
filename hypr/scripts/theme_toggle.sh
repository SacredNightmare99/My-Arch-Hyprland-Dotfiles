#!/bin/bash

#-----------------------------------------------------
# A script to toggle between two themes for Hyprland.
#
# REQUIRED:
# 1. swww:    For managing wallpapers (https://github.com/Horus645/swww).
# 2. Waybar:  The status bar.
#-----------------------------------------------------

#-----------#
# VARIABLES #
#-----------#

# State file to track the current theme
STATE_FILE="$HOME/.cache/theme_state"

# --- Theme 1: Linux ---
linux_wallpaper="$HOME/.config/hypr/wallpapers/sushi.jpg"
linux_waybar_dir="$HOME/.config/waybar/themes/linux"

# --- Theme 2: Windows ---
windows_wallpaper="$HOME/.config/hypr/wallpapers/windows.jpg"
windows_waybar_dir="$HOME/.config/waybar/themes/windows"

# --- Target Symlinks ---
# Waybar will always look for its config and style in this location.
# We will change where these links point to.
waybar_config_link="$HOME/.config/waybar/config"
waybar_style_link="$HOME/.config/waybar/style.css"
current_wallpaper_link="$HOME/.config/hypr/wallpapers/current.jpg"

#-----------#
# FUNCTIONS #
#-----------#

# Function to apply a theme
apply_theme() {
    local theme_name=$1
    local wallpaper=$2
    local waybar_dir=$3

    echo "Applying $theme_name theme..."

    # 1. Set the wallpaper
    swww img "$wallpaper" --transition-type wipe --transition-angle 30 --transition-step 90

    # 2. Update Waybar config and style
    # Remove old symlinks
    rm -f "$waybar_config_link" "$waybar_style_link" "$current_wallpaper_link"

    # Create new symlinks
    ln -s "$waybar_dir/config.jsonc" "$waybar_config_link"
    ln -s "$waybar_dir/style.css" "$waybar_style_link"
    ln -s "$wallpaper" "$current_wallpaper_link"

    # 3. Reload Waybar to apply changes
    killall -q waybar
    while pgrep -u $UID -x waybar >/dev/null; do sleep 0.1; done
    waybar &

    # 4. Updated SDDM Theme using the helper script
    # sudo /usr/local/bin/sddm_theme_switcher.sh "$theme_name-sddm-theme"

    # 5. Update the state file
    echo "$theme_name" > "$STATE_FILE"

    echo "$theme_name theme applied successfully!"
}


#------#
# MAIN #
#------#

# Get the current theme from the state file. Default to "dark" if not set.
current_theme=$(cat "$STATE_FILE" 2>/dev/null || echo "linux")

if [ "$current_theme" == "linux" ]; then
    # Switch to light theme
    apply_theme "windows" "$windows_wallpaper" "$windows_waybar_dir"
else
    # Switch to dark theme
    apply_theme "linux" "$linux_wallpaper" "$linux_waybar_dir"
fi

exit 0
