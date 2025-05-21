return {
  -- Plugin manager will manage itself
  {
    "folke/lazy.nvim",
    lazy = false,
    priority = 1000,
    version = "*"
  },

  -- AYU THEME
  {
    "Shatur/neovim-ayu",
    name = "ayu",
    lazy = false,
    priority = 900
  },

  -- Comment Helper
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end
  },

  -- mini.nvim
  {
    'echasnovski/mini.nvim',
    version = '*',
    lazy = false,
    config = function()
      require('mini.pairs').setup({})
      require('mini.comment').setup({
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
          end,
        }
      })

      require('mini.files').setup({
        mappings = {
          go_in_plus = '<CR>', -- default: membuka file (biasa)
          go_in = '<C-l>',     -- masuk ke folder
          go_out = '<C-h>',    -- keluar dari folder
          reset = '<BS>',      -- kembali ke root
        }
      })


      -- Function to open file in split/vsplit mode
      local MiniFiles = require('mini.files')
      local function open_in_split(split_cmd)
        local fs_entry = require('mini.files').get_fs_entry()
        if fs_entry == nil or fs_entry.fs_type ~= 'file' then return end
        vim.cmd(split_cmd .. ' ' .. vim.fn.fnameescape(fs_entry.path))
        MiniFiles.close()
      end

      -- Adding keymap
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set('n', '<C-v>', function() open_in_split('vsplit') end,
            { buffer = buf_id, desc = 'Open in vsplit' })
          vim.keymap.set('n', '<C-s>', function() open_in_split('split') end,
            { buffer = buf_id, desc = 'Open in split' })
        end,
      })
    end
  },


  -- MASON CORE
  {
    'mason-org/mason.nvim',
    event = { "BufReadPre", "BufNewFile" }, -- Load saat buka file
    config = function()
      require('mason').setup()
    end
  },

  -- MASON LSP BRIDGE
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "html", "cssls", "lua_ls", "ts_ls", "emmet_ls" },
        automatic_enable = false -- true just work for nvim > 0.11
      })
    end
  },

  -- LSP CONFIG
  {
    'neovim/nvim-lspconfig',
    event = "BufReadPre",
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    version = "0.1.7", -- now im use nvim 0.9, newest version compatible with nvim 0.10
  },


  -- TREESITTER
  -- make neovim smart to detect syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "html", "javascript", "json",
          "lua", "markdown", "typescript",
          "tsx"
        },
        auto_install = false,
        sync_install = false, -- Hindari block UI saat install
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false -- instead use smartindent from neovim
        },
      }
    end
  },


  -- Auto-tag untuk HTML/XML
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },


  -- Snippet engine + friendly snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  { "saadparwaiz1/cmp_luasnip" },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- Sources
      "hrsh7th/cmp-buffer",   -- Words from current buffer
      "hrsh7th/cmp-path",     -- Filesystem paths
      "hrsh7th/cmp-nvim-lsp", -- From LSP
      "LuaSnip",
      "cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),                        -- select previous completion list
          ["<C-j>"] = cmp.mapping.select_next_item(),                        -- select next completion list
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }), -- open completion manually
          ["<C-e>"] = cmp.mapping({                                          -- close completion
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping({ -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
          ["<C-l>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Explorer preview
  {
    'ibhagwan/fzf-lua',
    cmd = { "Ef", "Eb", "FzfLua" },
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional icons
    config = function()
      local fzf = require("fzf-lua")
      local file_utils = require('utils.file')

      fzf.setup({
        winopts = {
          preview = { hidden = 'hidden' }, -- nonaktifkan preview
        },
        files = {
          fzf_opts = { ['--prompt'] = 'Files> ' },
          actions  = {
            -- Default “Enter” opens the file
            ['default'] = function(sel)
              file_utils.open_path(sel[1])
            end,
          }
        }
      })
      -- open buffers
      vim.api.nvim_create_user_command("Eb", function()
        fzf.buffers()
      end, {})

      -- open files
      vim.api.nvim_create_user_command("Ef", function()
        fzf.files()
      end, {})
    end
  },
}

-- Comment helper
-- {
--   'numToStr/Comment.nvim',
--   event = { "BufReadPost", "BufNewFile" },
--   dependencies = {
--     "JoosepAlviste/nvim-ts-context-commentstring"
--   },
--   config = function()
--     require('Comment').setup {
--       ignore = '^$',
--       pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
--     }
--   end,
-- },

-- Auto Pairs
-- {
--   'windwp/nvim-autopairs',
--   -- event = "InsertEnter",
--   lazy = false,
--   config = function()
--     require('nvim-autopairs').setup({
--       check_ts = true,                                 -- Mengaktifkan integrasi Treesitter untuk mendeteksi tag HTML lebih akurat
--       map_cr = true,
--       disable_filetype = { "TelescopePrompt", "vim" }, -- Nonaktifkan di file tertentu jika perlu
--     })
--   end
-- },
