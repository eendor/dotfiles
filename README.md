# Osage desktop dotfiles

<img src=".config/waybar/assets/miku-face.png" alt="Miku artwork from the Waybar assets" width="72" align="right">

My Hyprland desktop and shell configs. Install the whole desktop profile or pick individual apps.

[Quick start](#quick-start) · [Dependencies](#dependencies) · [First launch](#first-launch) · [Restore](#restore)

## Quick start

```bash
git clone https://github.com/eendor/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh                  # Preview the desktop profile without changing files
./install.sh --apply desktop  # Install it
```

To install just the apps you use:

```bash
./install.sh kitty waybar
./install.sh --apply kitty waybar
```

The installer backs up existing targets before replacing them. It replaces whole app config directories rather than merging files. It does not install packages or touch your shell startup files unless you select the `shell` profile. Review that profile first: it assumes some of my local tools and paths.

## Dependencies

| Config | What to install |
| --- | --- |
| [Hyprland](.config/hypr) | A build that supports `hyprland.lua` and its `hl` API. A build that only reads `hyprland.conf` won't load this setup. |
| [Waybar](.config/waybar), [Kitty](.config/kitty), [Mako](.config/mako), [Rofi](.config/rofi) | `waybar`, `kitty`, `mako`, and a Wayland-capable Rofi. |
| [Wofi](.config/wofi), [Fastfetch](.config/fastfetch), [Cava](.config/cava), [Fontconfig](.config/fontconfig) | The corresponding packages, if you use them. |

Install packages with your distro's package manager. For optional shortcuts, install the tools you plan to use: Nautilus, Firefox, `grim`, `slurp`, `wl-copy`, `brightnessctl`, `playerctl`, and `wpctl`. Install `swaybg` for the wallpaper startup command.

## First launch

1. Start a fresh Hyprland session after installing the configs. **Super+Enter** opens Kitty; **Super+Space** opens Rofi.
2. The installer skips my monitor and workspace overrides. Hyprland uses automatic monitor placement; see the [monitor example](.config/hypr/monitors.lua) to set up your own layout.
3. The wallpaper, fonts, cursor and icon themes, and custom helpers in `~/.local/bin` aren't bundled. Set your own fonts and themes. To use the wallpaper startup command, put an image at `~/.local/share/wallpapers/osage-spot-late.png` or edit the [Hyprland config](.config/hypr/hyprland.lua).
4. If the custom desktop launcher isn't installed, Hyprland starts Waybar directly. Widgets such as weather and some shortcuts still need local helpers. Remove or replace those commands in the [Waybar config](.config/waybar/config.jsonc) or the Hyprland config.

## Restore

The installer prints a backup path such as `~/.dotfiles-backup.ABC12345`. To restore Kitty, substitute your actual backup path:

```bash
mv ~/.config/kitty ~/.config/kitty.from-dotfiles
mv ~/.dotfiles-backup.ABC12345/.config/kitty ~/.config/kitty
```

If no config existed before installation, just move the installed config aside.
