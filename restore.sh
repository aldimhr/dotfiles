#!/bin/bash

DATE=$(date +%Y-%m-%d)
BACKUP_DIR=$(pwd)/backup/$DATE
FILES=(bashrc gitconfig zshrc tmux.conf bash_aliases zsh_aliases)
NVIM_DIR="$HOME/.config/nvim"
HYPR_DIR="$HOME/.config/hypr"
KITTY_DIR="$HOME/.config/kitty"
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

# Restore Hypr directory
if [ -d "$DOTFILES_DIR/hypr" ]; then
  if [ -L "$HYPR_DIR" ]; then
    echo "$HYPR_DIR is already a symlink. Skipping restore."
  else
    echo "Moving existing $HYPR_DIR to $BACKUP_DIR/ and create symlink"
    mv "$HYPR_DIR" "$BACKUP_DIR/"
    ln -sf "$DOTFILES_DIR/hypr" "$HYPR_DIR"
  fi
fi

# Restore Kitty directory
if [ -d "$DOTFILES_DIR/kitty" ]; then
  if [ -L "$KITTY_DIR" ]; then
    echo "$KITTY_DIR is already a symlink. Skipping restore."
  else
    echo "Moving existing $KITTY_DIR to $BACKUP_DIR/ and create symlink"
    mv "$KITTY_DIR" "$BACKUP_DIR/"
    ln -sf "$DOTFILES_DIR/kitty" "$KITTY_DIR"
  fi
fi


echo "[Restore] Done."

