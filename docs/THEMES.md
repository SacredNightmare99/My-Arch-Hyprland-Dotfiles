# Themes and Wallpaper Workflow

The desktop theme system is handled by:

- `hypr/.config/hypr/scripts/theme_toggle.sh`
- `hypr/.config/hypr/scripts/wallpaper_switch.sh`

## Available themes

- Gruvbox
- Red
- Blue
- Windows

## How theme switching works

When you run **theme toggle** (`Super + Shift + T`):

1. A `wofi` menu is shown.
2. Selected theme resources are mapped:
   - Waybar config and style
   - Wofi style
   - Wlogout style
   - Wallpaper directory
3. Symlinks are updated:
   - `~/.config/waybar/config.jsonc`
   - `~/.config/waybar/style.css`
   - `~/.config/wofi/style.css`
   - `~/.config/wlogout/style.css`
   - `~/.config/hypr/wallpapers/current.jpg`
4. `waybar` is restarted.
5. Theme and wallpaper state are saved in `~/.cache`.

## State files

The scripts track state in:

- `~/.cache/theme_state`
- `~/.cache/wallpaper_state_gruvbox`
- `~/.cache/wallpaper_state_red`
- `~/.cache/wallpaper_state_blue`
- `~/.cache/wallpaper_state_windows`

This preserves your last selected wallpaper per theme.

## Wallpaper switching

`Super + T` opens wallpaper selection for the **current** theme only.

- Images are loaded from `~/.config/hypr/wallpapers/<theme>/`
- Accepted formats: `.jpg`, `.jpeg`, `.png`
- Selection is applied using `swww`

## Adding a new theme

To add theme `mytheme`, create:

- `waybar/.config/waybar/themes/mytheme/config.jsonc`
- `waybar/.config/waybar/themes/mytheme/style.css`
- `wofi/.config/wofi/themes/mytheme/style.css`
- `wlogout/.config/wlogout/themes/mytheme/style.css`
- `hypr/.config/hypr/wallpapers/mytheme/*`

Then update `theme_toggle.sh`:

- Declare paths for `mytheme`
- Add `mytheme` to `THEME_LIST`
- Add a case entry that calls `apply_theme`
