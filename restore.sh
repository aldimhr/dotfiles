#!/bin/bash

DATE=$(date +%Y-%m-%d)
BACKUP_DIR=$(pwd)/backup/$DATE
FILES=(bashrc gitconfig zshrc tmux.conf bash_aliases)
NVIM_DIR="$HOME/.config/nvim"
DOTFILES_DIR=$(pwd)

echo "[Restore] Starting..."

# Restore dotfiles
for file in "${FILES[@]}"; do
  target="$HOME/.$file"
  source="$DOTFILES_DIR/$file"
  
  if [ -f "$source" ]; then
    # Is symlink file?
    if [ -L "$target" ]; then
      echo ".$file is already a symlink. Skipping restore."
    else
      echo "Moving existing $target to $BACKUP_DIR/ and create symlink"
      mv "$target" "$BACKUP_DIR/"
      ln -sf "$source" "$target"
    fi
  fi
done

# Restore Neovim directory
if [ -d "$DOTFILES_DIR/nvim" ]; then
  if [ -L "$NVIM_DIR" ]; then
    echo "$NVIM_DIR is already a symlink. Skipping restore."
  else
    echo "Moving existing $NVIM_DIR to $BACKUP_DIR/ and create symlink"
    mv "$NVIM_DIR" "$BACKUP_DIR/"
    ln -sf "$DOTFILES_DIR/nvim" "$NVIM_DIR"
  fi
fi

echo "[Restore] Done."

