#!/bin/bash

# -------------------------------------------------
# Wallpaper switcher
# -------------------------------------------------

THEME_STATE_FILE="$HOME/.cache/theme_state"
WALL_STATE_PREFIX="$HOME/.cache/wallpaper_state_"
WALL_BASE_DIR="$HOME/.config/hypr/wallpapers"
current_wallpaper_link="$HOME/.config/hypr/wallpapers/current.jpg"

# Fallback theme if none saved yet
theme="gruvbox"
if [ -f "$THEME_STATE_FILE" ]; then
    read -r saved_theme < "$THEME_STATE_FILE"
    [ -n "$saved_theme" ] && theme="$saved_theme"
fi

wallpaper_dir="$WALL_BASE_DIR/$theme"

if [ ! -d "$wallpaper_dir" ]; then
    echo "Wallpaper directory '$wallpaper_dir' not found."
    exit 1
fi

# Build list of wallpapers (file names only)
wallpaper_list=$(find "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -printf "%f\n" | sort)

if [ -z "$wallpaper_list" ]; then
    echo "No wallpapers found in '$wallpaper_dir'."
    exit 1
fi

selected=$(echo "$wallpaper_list" | wofi --dmenu -p "Select Wallpaper ($theme)")

[ -z "$selected" ] && exit 0

full_path="$wallpaper_dir/$selected"

# Ensure swww-daemon is running
if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon &
    sleep 0.4
fi

# Update symlink + show wallpaper
rm -f "$current_wallpaper_link"
ln -s "$full_path" "$current_wallpaper_link"

swww img "$full_path" --transition-type fade --transition-step 50

# Save wallpaper state for this theme
echo "$full_path" > "${WALL_STATE_PREFIX}${theme}"

