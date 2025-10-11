#!/bin/bash

DATE=$(date +%Y-%m-%d)
BACKUP_DIR=$(pwd)/backup/$DATE
mkdir -p "$BACKUP_DIR"
DOTFILES_DIR=$(pwd)

FILES=(bashrc gitconfig zshrc tmux.conf bash_aliases zsh_aliases)
NVIM_DIR="$HOME/.config/nvim"

echo "[Backup] Starting..."

# Backup dotfiles
for file in "${FILES[@]}"; do
  target="$HOME/.$file"
  source="$DOTFILES_DIR/$file"
  
  if [ -f "$target" ]; then
    # Is target symlink?
    if [ -L "$target" ]; then
      echo "$file is already a symlink. Skipping backup."
    else
      echo "Moving $target to $BACKUP_DIR/ and copying to dotfiles root"
      cp "$target" "$DOTFILES_DIR/$file"
      mv "$target" "$BACKUP_DIR/"
      ln -sf "$source" "$target"
    fi
  fi
done

# Backup Neovim directory
if [ -d "$NVIM_DIR" ]; then
  # Is nvim symlink?
  if [ -L "$NVIM_DIR" ]; then
    echo "$NVIM_DIR is already a symlink. Skipping backup."
  else
    echo "Moving $NVIM_DIR to $BACKUP_DIR/ and copying to dotfiles root"
    cp -r "$NVIM_DIR" "$DOTFILES_DIR/nvim"
    mv "$NVIM_DIR" "$BACKUP_DIR/"
    ln -sf "$DOTFILES_DIR/nvim" "$NVIM_DIR"
  fi
fi

echo "[Backup] Done."

