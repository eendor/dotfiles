#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
usage() {
  echo "Usage: $0 [--apply] [desktop|shell|hypr|waybar|kitty|mako|rofi|wofi|fastfetch|cava|fontconfig ...]"
  echo 'Without --apply, preview only. With no profile specified, select desktop.'
}
: "${HOME:?HOME must be set}"
desktop=(hypr waybar kitty mako rofi wofi fastfetch cava fontconfig)
targets=()
add() {
  local target
  for target in "${targets[@]}"; do [[ $target != "$1" ]] || return 0; done
  targets+=("$1")
}
add_desktop() { local app; for app in "${desktop[@]}"; do add ".config/$app"; done; }
apply=false
for arg; do
  case $arg in
    --apply) apply=true ;;
    -h|--help) usage; exit 0 ;;
    desktop) add_desktop ;;
    shell) for file in .bashrc .bash_profile .bash_logout .zshrc .zprofile .Xresources; do add "$file"; done ;;
    hypr|waybar|kitty|mako|rofi|wofi|fastfetch|cava|fontconfig) add ".config/$arg" ;;
    *) usage >&2; exit 2 ;;
  esac
done
if (( ${#targets[@]} == 0 )); then add_desktop; fi
for rel in "${targets[@]}"; do
  dest=$HOME/$rel
  parent=$(realpath -m -- "$(dirname -- "$dest")")
  if [[ $(pwd -P) == "$parent/${rel##*/}" || $(pwd -P) == "$parent/${rel##*/}/"* || $(realpath -- "$rel") == "$(realpath -m -- "$dest")" ]]; then
    printf 'Clone into a separate directory first (overlap at %s).\n' "$dest" >&2
    exit 1
  fi
  if [[ -e $dest || -L $dest ]]; then
    printf 'Replace (back up first): %s\n' "$dest"
  else
    printf 'Install: %s\n' "$dest"
  fi
done
if ! $apply; then echo 'Dry run only. Add --apply to install.'; exit 0; fi
backup=$(mktemp -d "$HOME/.dotfiles-backup.XXXXXXXX")
printf 'Backup directory: %s\n' "$backup"
for rel in "${targets[@]}"; do
  dest=$HOME/$rel
  mkdir -p -- "$(dirname -- "$dest")"
  if [[ -e $dest || -L $dest ]]; then
    mkdir -p -- "$backup/$(dirname -- "$rel")"
    mv -- "$dest" "$backup/$rel"
  fi
  if [[ $rel == .config/hypr ]]; then
    mkdir -- "$dest"
    for file in "$rel"/*; do
      case ${file##*/} in monitors.lua|monitors.conf|workspaces.conf) continue ;; esac
      cp -a -- "$file" "$dest/"
    done
  else
    cp -a -- "$rel" "$dest"
  fi
done
