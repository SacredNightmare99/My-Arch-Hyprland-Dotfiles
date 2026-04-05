#!/bin/bash
# =============================
# wallpaper_switch.sh
# =============================

THEME_STATE_FILE="$HOME/.cache/theme_state"
WALL_STATE_PREFIX="$HOME/.cache/wallpaper_state_"
WALL_BASE_DIR="$HOME/.config/hypr/wallpapers"
current_wallpaper_link="$HOME/.config/hypr/wallpapers/current"

# Detect current theme
theme="gruvbox"
if [ -f "$THEME_STATE_FILE" ]; then
    read -r saved_theme < "$THEME_STATE_FILE"
    [ -n "$saved_theme" ] && theme="$saved_theme"
fi

wallpaper_dir="$WALL_BASE_DIR/$theme"

[ ! -d "$wallpaper_dir" ] && exit 1

# List wallpapers (images + videos)
wallpaper_list=$(find "$wallpaper_dir" -maxdepth 1 -type f \( \
    -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.mp4' \
\) -printf "%f\n" | sort)

[ -z "$wallpaper_list" ] && exit 1

selected=$(echo "$wallpaper_list" | wofi --dmenu -p "Select Wallpaper ($theme)")
[ -z "$selected" ] && exit 0

full_path="$wallpaper_dir/$selected"

# ----------------------
# Wallpaper setter
# ----------------------
set_wallpaper() {
    local file="$1"

    pkill mpvpaper >/dev/null 2>&1

    if [[ "$file" =~ \.mp4$ ]]; then
        pkill awww-daemon >/dev/null 2>&1
        mpvpaper -o "loop --no-audio --hwdec=auto --vo=gpu --profile=fast" "*" "$file" &
    else
        if ! pgrep -x "awww-daemon" >/dev/null; then
            awww-daemon &
            sleep 0.4
        fi
        awww img "$file" --transition-type fade --transition-step 50
    fi
}

# Apply wallpaper
set_wallpaper "$full_path"

# Update symlink
rm -f "$current_wallpaper_link"
ln -s "$full_path" "$current_wallpaper_link"

# Save state
echo "$full_path" > "${WALL_STATE_PREFIX}${theme}"

