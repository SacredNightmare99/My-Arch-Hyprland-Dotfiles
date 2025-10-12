# My Arch Hyprland Dotfiles

A sleek, developer-focused, and highly themeable Hyprland configuration managed with GNU Stow. This setup is built to be both beautiful and functional, featuring a dynamic theme switcher that instantly changes the look and feel of your entire desktop environment.

## Key Features

  * **Dynamic Theme Switcher**: Press `Super + T` to instantly switch between multiple themes (Gruvbox, Red, Windows) using a `wofi` menu.
  * **Cohesive Theming**: The theme script updates Waybar, Wofi, Wlogout, and the desktop wallpaper simultaneously for a consistent aesthetic.
  * **Developer-Ready Neovim**: A modern Neovim setup configured in Lua (`init.lua`) with LSP, completion, Telescope, and specific tools for Flutter/Dart development.
  * **Clean Management**: Uses `stow` to cleanly manage dotfiles by symlinking them from this repository to their correct locations.
  * **Modern Components**: Built with modern Wayland tools like `Waybar`, `Wofi`, `swww`, and `wlogout`.
  * **Practical Keybindings**: Intuitive and easy-to-remember keybindings for window management, application launching, and system controls.

## Themes

The theme switcher script (`theme_toggle.sh`) controls the following themes:

1.  **Gruvbox**: A cozy, cyberpunk-inspired theme using the `sushi.jpg` wallpaper and a gruvbox color palette across all UI elements.
   <img width="1921" height="1081" alt="image" src="https://github.com/user-attachments/assets/93570e36-dd66-44af-a569-b2ae748553c7" />

2.  **Red**: A vibrant, abstract theme featuring the `red.jpg` wallpaper and a fiery red/orange color scheme.
   <img width="1921" height="1081" alt="image" src="https://github.com/user-attachments/assets/c3ec7df7-67ce-496e-931e-348e297ec050" />

3.  **Windows**: A minimalist, dark theme using [win-10-style-waybar](https://github.com/TheFrankyDoll/win10-style-waybar) and a wallpaper with a clean, red-accented look.
   <img width="1921" height="1081" alt="image" src="https://github.com/user-attachments/assets/127dd675-ea4e-47fd-9b7f-b490d4337ed2" />
   
## Dependencies

To use this configuration, you will need to install the following packages.

**Core Components:**

  * `hyprland`: The Wayland compositor.
  * `stow`: For managing dotfiles.
  * `waybar`: The status bar.
  * `wofi`: The application launcher.
  * `wlogout`: The logout menu.
  * `hyprlock`: The screen locker.
  * `swww`: For setting wallpapers.

**Terminal & Utilities:**

  * `ghostty`: The terminal emulator.
  * `yazi`: A terminal file manager.
  * `wl-paste` & `cliphist`: For clipboard management.
  * `hyprshot`: For taking screenshots.
  * `nm-applet`: Network manager tray icon.
  * `pavucontrol`: PulseAudio volume control.
  * `brightnessctl`: For controlling screen brightness.
  * `playerctl`: For media key controls.

**Fonts:**

  * `ttf-jetbrains-mono-nerd`: The primary font used in Waybar and other components.
  * `noto-fonts-emoji`: For emoji support.

**For Neovim:**

  * `neovim`: The editor.
  * `vim-plug`: Plugin manager.
  * `ripgrep`: For Telescope's live grep functionality.
  * `flutter-sdk`: For Flutter/Dart development.

### Example Installation on Arch Linux

```bash
sudo pacman -S hyprland stow waybar wofi wlogout hyprlock swww ghostty yazi wl-paste cliphist hyprshot network-manager-applet pavucontrol brightnessctl playerctl ttf-jetbrains-mono-nerd neovim ripgrep
```

## Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/SacredNightmare99/My-Arch-Hyprland-Dotfiles ~/.dotfiles
    ```

2.  **Backup/Remove Existing Configs**: If you have existing configurations (e.g., in `~/.config/hypr`, `~/.config/waybar`), make sure to back them up and remove them to avoid conflicts with `stow`.

3.  **Stow the Dotfiles**: Navigate to the cloned directory and use `stow` to create the symbolic links for all the packages.

    ```bash
    cd ~/.dotfiles
    stow hypr nvim waybar wlogout wofi
    ```

4.  **Initialize Wallpaper Daemon**: Run `swww-daemon` so it's ready to handle wallpapers. It is also configured to start automatically in `hyprland.conf`.

5.  **Install Neovim Plugins**: Open Neovim and run `:PlugInstall` to install all the plugins listed in `init.lua`.

6.  **Reboot or Re-login**: Log into your Hyprland session, and everything should be loaded.

## ⌨️ Keybindings

The main modifier key is the **Super** key (Windows key).

| Keybinding              | Action                                        |
| ----------------------- | --------------------------------------------- |
| `Super + T`             | Open theme switcher menu (wofi)      |
| `Super + Return`        | Launch Terminal (`ghostty`)        |
| `Super + R`             | Launch App Menu (`wofi`)             |
| `Super + B`             | Launch Browser                       |
| `Super + E`             | Launch File Manager (`yazi`)       |
| `Super + Q`             | Close active window                  |
| `Super + L`             | Open logout menu (`wlogout`)         |
| `Super + V`             | Show clipboard history (cliphist)    |
| `Print`                 | Take a region screenshot (hyprshot)  |
| `Super + F`             | Toggle fullscreen                    |
| `Super + A`             | Toggle floating window               |
| `Super + [Arrow Keys]`  | Move focus                           |
| `Super + [1-9]`         | Switch to workspace 1-9              |
| `Super + SHIFT + [1-9]` | Move active window to workspace 1-9  |
| `Super + S`             | Toggle special workspace (scratchpad)|
