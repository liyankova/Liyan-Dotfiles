# Liyan's Hyprland Dotfiles

A clean, dynamic, and productive Hyprland setup. This configuration is themed on the fly using **Wallust**, creating a cohesive look and feel based on the current wallpaper. It is managed using **GNU Stow**.


---

## 🏗️ Structure

This repository uses a single-package `stow` structure. All configuration files are located inside the `dots` directory, which mirrors the `$HOME` directory structure.

```
dotfiles/
└── dots/
    ├── .config/
    │   ├── hypr/
    │   ├── kitty/
    │   ├── waybar/
    │   ├── wallust/
    │   └── ...
    └── .zshrc
```

---

## ⚙️ Dependencies

These packages are required for the core components of this setup to function correctly.

### Essential Packages

These are the absolute minimum required for the WM, bar, launcher, and theming engine to work.

```bash
# Using pacman (Arch Linux)
sudo pacman -S hyprland waybar rofi-wayland wlogout kitty thunar \
               swww wallust swaync hypridle hyprlock \
               stow jq polkit-kde-agent
```

### Optional Packages (Recommended)

These packages provide functionality for the helper scripts and improve the overall experience.

```bash
# Using paru for AUR packages and pacman for others
paru -S oh-my-posh-bin
sudo pacman -S pavucontrol brightnessctl pamixer grim slurp swappy cliphist \
               btop nwg-look qt5ct qt6ct kvantum
```

---

## 🚀 Installation

Follow these steps to deploy the dotfiles on your system.

### 1. Clone the Repository

Clone this repository into your home directory.

```bash
cd ~
git clone [https://github.com/liyankova/Liyan-Dotfiles.git](https://github.com/liyankova/Liyan-Dotfiles.git)
```

### 2. Backup Existing Configs (Optional but Recommended)

If you have existing configurations,



### 3. Deploy with GNU Stow

From the root of the `dotfiles` repository, deploy the `dots` package. This will create symlinks for all configurations to their correct locations.

```bash
# Ensure you are in the 'dotfiles' directory
cd ~/dotfiles

# Stow the 'dots' package
stow dots
```

---

## 🛠️ Managing the Dotfiles

All management is done from the root of the `~/dotfiles` repository.

* **Install / Update Symlinks:** `stow dots`
* **Remove Symlinks:** `stow -D dots`

### A Note on Portability

All scripts and configuration files use `$HOME` or `~` to reference the home directory. This ensures that the configuration is portable and will work for any user without modification. Avoid using hardcoded paths like `/home/liyan/...`.

---
*Maintained by @liyankova*
