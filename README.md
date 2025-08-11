# My Dotfiles for Arch Linux with Hyprland

These are my personal dotfiles for my Arch Linux setup, using Hyprland as the window manager.

## Overview

This setup is designed for a simple and efficient workflow, with a focus on minimalism and performance.

- **Window Manager**: [Hyprland](https://hyprland.org/)
- **Status Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Terminal Emulator**: [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Shell**: [Fish](https://fishshell.com/) (run inside Kitty)
- **Text Editor**: [Neovim](https://neovim.io/)
- **Application Launcher**: [Wofi](https://hg.sr.ht/~scoopta/wofi)

## Configuration

### Hyprland

The Hyprland configuration is located in `hypr/hyprland.conf`. It includes:

- **Keybindings**: Custom keybindings for launching applications, managing windows, and controlling system settings.
- **Window Rules**: Rules for specific applications to control their behavior.
- **Startup Applications**: Applications that are automatically launched when Hyprland starts.

### Waybar

The Waybar configuration is located in the `waybar/` directory.

- `config.jsonc`: The main configuration file for Waybar, defining the modules and their settings.
- `style.css`: The stylesheet for Waybar, controlling the look and feel of the bar.
- `autohide_waybar.sh`: A script to automatically hide and show the Waybar.

### Neovim

The Neovim configuration is located in `nvim/init.vim`. It's a minimal configuration for basic text editing.

