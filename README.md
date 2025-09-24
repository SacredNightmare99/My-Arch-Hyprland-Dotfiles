# My Arch Linux Hyprland Dotfiles

Welcome to my curated collection of configuration files ("dotfiles") for an Arch Linux setup running the Hyprland compositor. This repository is designed to provide a minimal, efficient, and visually appealing desktop environment using Wayland technologies.

---

## Repository Structure

```
.
├── .gitignore
├── README.md
├── hypr/
│   ├── hyprland.conf
│   ├── hyprlock.conf
│   ├── scripts/
│   └── wallpapers/
├── nvim/
│   └── init.vim
├── waybar/
│   ├── config        (symlink or config file)
│   ├── style.css     (symlink or stylesheet)
│   └── themes/
└── wlogout/
    ├── layout
    └── style.css
```

---

## Main Components

### Hyprland (`hypr/`)
- **hyprland.conf**: Main Hyprland compositor configuration — sets keybindings, window rules, and startup applications.
- **hyprlock.conf**: Configuration for Hyprlock (lock screen).
- **scripts/**: (Place for utility scripts used by the compositor.)
- **wallpapers/**: (Your wallpapers for dynamic backgrounds.)

### Neovim (`nvim/`)
- **init.vim**: Minimal but effective Neovim configuration for fast, distraction-free coding and editing. (currently setup for Flutter Dev)

### Waybar (`waybar/`)
- **config**: Configuration symlink for Waybar modules and behaviors.
- **style.css**: Custom CSS (or symlink) for bar appearance.
- **themes/**: Directory for alternate Waybar themes.

### Wlogout (`wlogout/`)
- **layout**: Layout file for wlogout menu (logout/reboot/shutdown screen).
- **style.css**: CSS theme for wlogout menu.

---

## License

MIT License unless otherwise noted.

---

