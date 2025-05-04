-- set <leader> key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable unused plugin
vim.g.loaded_tutor = 1        -- Plugin tutor (tutorial interaktif Neovim).
vim.g.loaded_2html_plugin = 1 -- Plugin 2html.vim yang mengkonversi kode ke HTML.
vim.g.loaded_zipPlugin = 1    -- Dukungan untuk membaca/menulis file ZIP.
vim.g.loaded_tarPlugin = 1    -- Dukungan untuk file TAR (archive format Unix).

-- setup path for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- check lazy.nvim is exist
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

-- adding lazy.nvim to runtime
vim.opt.rtp:prepend(lazypath)

-- impatient.nvim but build-in
vim.loader.enable()

-- Setup plugin manager
require("lazy").setup("plugins", {
    defaults = { lazy = true },
    checker = { enabled = true }, -- auto check updates
})

-- mod require
require("config.theme")
require("config.options")
require("config.lsp")
require("config.autocmd")
require("config.keymaps")
