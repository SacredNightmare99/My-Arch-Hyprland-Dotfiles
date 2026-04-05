#!/bin/bash

CONFIG="$HOME/.config/hypr/themes/themes.json"
BASE="$HOME/.config/hypr/themes"

THEME_STATE="$HOME/.cache/theme_state"
WALL_STATE_PREFIX="$HOME/.cache/wallpaper_state_"

# symlinks
waybar_config="$HOME/.config/waybar/config.jsonc"
waybar_style="$HOME/.config/waybar/style.css"
wofi_style="$HOME/.config/wofi/style.css"
wlogout_style="$HOME/.config/wlogout/style.css"
current_wall="$HOME/.config/hypr/wallpapers/current"

# ----------------------
# wallpaper setter
# ----------------------
set_wallpaper() {
    local file="$1"

    pkill mpvpaper >/dev/null 2>&1

    if [[ "$file" =~ \.mp4$ ]]; then
        pkill awww-daemon >/dev/null 2>&1
        mpvpaper -o "loop --no-audio --hwdec=auto --vo=gpu --profile=fast" "*" "$file" &
    else
        if ! pgrep -x "awww-daemon" >/dev/null; then
            awww-daemon & sleep 0.3
        fi
        awww img "$file" --transition-type none
    fi
}

# ----------------------
# pick wallpaper
# ----------------------
get_wallpaper() {
    local theme="$1"

    # try saved
    local state="${WALL_STATE_PREFIX}${theme}"
    if [ -f "$state" ]; then
        local saved=$(cat "$state")
        [ -f "$saved" ] && echo "$saved" && return
    fi

    # fallback: first matching tag
    jq -r --arg theme "$theme" '
    .themes[$theme].tags as $tags |
    .wallpapers[] |
    select(any(.tags[]; . as $t | $tags | index($t))) |
    .path
    ' "$CONFIG" | head -n1 | while read -r path; do
        echo "$BASE/$path"
    done
}

# ----------------------
# apply theme
# ----------------------
apply_theme() {
    local theme="$1"

    wall=$(get_wallpaper "$theme")

    if [ -z "$wall" ]; then
      notify-send "Theme Error" "No wallpaper found for theme: $theme"
      exit 1
    fi

    set_wallpaper "$wall"

    waybar_key=$(jq -r ".themes[\"$theme\"].components.waybar" "$CONFIG")
    wofi_key=$(jq -r ".themes[\"$theme\"].components.wofi" "$CONFIG")
    wlogout_key=$(jq -r ".themes[\"$theme\"].components.wlogout" "$CONFIG")

    waybar_path="$BASE/$(jq -r ".components.waybar[\"$waybar_key\"]" "$CONFIG")"
    wofi_path="$BASE/$(jq -r ".components.wofi[\"$wofi_key\"]" "$CONFIG")"
    wlogout_path="$BASE/$(jq -r ".components.wlogout[\"$wlogout_key\"]" "$CONFIG")"

    rm -f "$waybar_config" "$waybar_style" "$wofi_style" "$wlogout_style" "$current_wall"

    [ ! -f "$waybar_path/config.jsonc" ] && echo "Waybar config missing: $waybar_path"
    [ ! -f "$wofi_path" ] && echo "Wofi missing: $wofi_path"
    [ ! -f "$wlogout_path" ] && echo "Wlogout missing: $wlogout_path"

    ln -s "$waybar_path/config.jsonc" "$waybar_config"
    ln -s "$waybar_path/style.css" "$waybar_style"
    ln -s "$wofi_path" "$wofi_style"
    ln -s "$wlogout_path" "$wlogout_style"
    ln -s "$wall" "$current_wall"

    killall -q waybar
    while pgrep -x waybar >/dev/null; do sleep 0.1; done
    waybar &

    echo "$theme" > "$THEME_STATE"
    echo "$wall" > "${WALL_STATE_PREFIX}${theme}"
}

# ----------------------
# menu
# ----------------------
themes=$(jq -r '.themes | keys[]' "$CONFIG")

selected=$(echo "$themes" | wofi --dmenu -p "Theme")

[ -z "$selected" ] && exit 0

apply_theme "$selected"

