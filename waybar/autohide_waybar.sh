#!/bin/bash

# Function to check if any window is currently focused
is_window_focused() {
    local title
    title=$(hyprctl activewindow -j | jq -r '.title')
    [[ "$title" != "null" && "$title" != "" ]]
}

# Function to check if mouse is at top edge
is_cursor_top() {
    local y
    y=$(hyprctl cursorpos | cut -d ',' -f2)
    [[ "$y" -lt 5 ]]
}

# Function to check if the focused window is floating
is_window_floating() {
    local floating
    floating=$(hyprctl activewindow -j | jq -r '.floating')
    [[ "$floating" == "true" ]]
}

# Main loop
while true; do
    if is_cursor_top || ! is_window_focused || is_window_floating; then
        # Show Waybar
        if ! pgrep -x waybar > /dev/null; then
            waybar &
        fi
    else
        # Hide Waybar
        if pgrep -x waybar > /dev/null; then
            killall waybar
        fi
    fi

    sleep 0.3
done

