# Dotfiles Backup & Sync Utility

A simple Bash script to backup existing dotfiles, sync them to a repository, and manage them via symbolic links.

## Features

- 📅 **Date-based Backups**: Creates backups in `backup/YYYY-MM-DD/` to preserve previous configurations.
- 🔗 **Automatic Symlinks**: Replaces dotfiles in `$HOME` with symlinks pointing to your repo.
- 🛠 **Multi-File Support**: Handles common dotfiles (`.bashrc`, `.gitconfig`, `.zshrc`, `.tmux.conf`, `.bash_aliases`, `.config/nvim`).

## Prerequisites

- **Bash**
- **Git**

## Usage

1. **Clone repo**:
   ```bash
   git clone https://github.com/aldimhr/dotfiles.git
   cd dotfiles
   ```

2. Run the backup script:
   ```bash
   ./backup.sh
   ```

3. Run the restore script:
   ```bash
   ./restore.sh
   ```
   
## Directory Structure
After first run:
   ```
   dotfiles/
   ├── backup/
   │   └── 2025-05-05/  # Example backup
   │       ├── bashrc
   │       ├── nvim/
   │       └── ...
   ├── bashrc            # Active bash config
   ├── nvim/             # Active Neovim config
   └── backup.sh         
   └── restore.sh         
   ```

## Important Notes
- ⚠️ Existing Symlinks: Script skips files that are already symlinks.
- ⚠️ Overwrite Warning: Existing files in the repo will be overwritten by your current $HOME versions during backup.
- 🔗 Symlink Behavior: Changes made through symlinks (in $HOME) directly modify repo files.

## Compatibility
Tested on Ubuntu 24.04
