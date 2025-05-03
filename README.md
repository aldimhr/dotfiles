# Dotfiles Backup & Sync Utility

A simple Bash script to backup existing dotfiles, sync them to a repository, and manage them via symbolic links.

## Features

- 📅 **Date-based Backups**: Creates backups in `backup/YYYY-MM-DD/` to preserve previous configurations.
- 🔗 **Automatic Symlinks**: Replaces dotfiles in `$HOME` with symlinks pointing to your repo.
- 🛠 **Multi-File Support**: Handles common dotfiles (`.bashrc`, `.gitconfig`, etc.).
- ⌨ **Neovim Config Support**: Backs up and links the entire `~/.config/nvim` directory.

## Prerequisites

- **Bash**
- **Git**
- **Neovim** (optional, if using NVIM configs)

## Usage

1. **Clone repo**:
   ```bash
   git clone https://github.com/aldimhr/dotfiles.git
   cd dotfiles
   ```

2. Make this your dotfiles directory
   Place all your configuration files directly in the repo root:
```
dotfiles/
├── bashrc
├── gitconfig
├── nvim/
└── backup.sh
```

3. Run the backup script:
```bash
./backup.sh
```

4. Commit your changes:
```bash
git add .
git commit -m "Update dotfiles"
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
└── backup.sh         # This script
```

## Important Notes
- ⚠️ Existing Symlinks: Script skips files that are already symlinks.
- ⚠️ Overwrite Warning: Existing files in the repo will be overwritten by your current $HOME versions during backup.
- 🔗 Symlink Behavior: Changes made through symlinks (in $HOME) directly modify repo files.

## Compatibility
Tested on Ubuntu 24.04
