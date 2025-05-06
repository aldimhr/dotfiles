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

  -- MASON CORE
  {
    'williamboman/mason.nvim',
    event = { "BufReadPre", "BufNewFile" }, -- Load saat buka file
    config = function()
      require('mason').setup()
    end
  },

  -- MASON LSP BRIDGE
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "html", "cssls", "lua_ls", "ts_ls", "emmet_ls" },
      })
    end
  },

  -- LSP CONFIG
  {
    'neovim/nvim-lspconfig',
    event = "BufReadPre",
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    version = "0.1.7", -- now im use nvim 0.9, newest version compatible with nvim 0.10
  },


  -- Comment helper
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end
  },
  {
    'numToStr/Comment.nvim',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring"
    },
    config = function()
      require('Comment').setup {
        ignore = '^$',
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
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

  -- Auto Pairs
  {
    'windwp/nvim-autopairs',
    -- event = "InsertEnter",
    lazy = false,
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,                                 -- Mengaktifkan integrasi Treesitter untuk mendeteksi tag HTML lebih akurat
        map_cr = true,
        disable_filetype = { "TelescopePrompt", "vim" }, -- Nonaktifkan di file tertentu jika perlu
      })
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
    event = "InsertEnter",
    dependencies = {
      -- Sources
      "hrsh7th/cmp-buffer",   -- Words from current buffer
      "hrsh7th/cmp-path",     -- Filesystem paths
      "hrsh7th/cmp-nvim-lsp", -- From LSP
      "nvim-autopairs",
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
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              -- kalau popup gak muncul, panggil default <CR>:
              fallback()
            end
          end, { "i", "s" }),

          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Integrasi autopairs dengan cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
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
            -- 1) Default “Enter” opens the file
            ['default'] = function(sel)
              file_utils.open_path(sel[1])
            end,

            -- create new file or folder
            ['ctrl-n'] = function()
              vim.ui.input({ prompt = "New file path: " }, function(input)
                if input and input ~= "" then
                  require('utils.file').edit_or_create_file(input)
                else
                  print("Path is empty")
                end
              end)
            end,

            -- delete file or folder
            ['ctrl-d'] = function(sel)
              local path = sel[1] or ""
              local plain = require('utils.file').strip_icons(path)
              require('utils.file').delete_path_input(plain)
              vim.schedule(function() require('fzf-lua').files() end)
            end,

            -- rename file or folder
            -- ['ctrl-r'] = function(sel)
            --   local plain = file_utils.strip_icons(sel[1])
            --   file_utils.rename_path(plain)
            --   vim.schedule(function() fzf.files() end)
            -- end,

            -- move file
            ['ctrl-r'] = function(sel)
              local plain = file_utils.strip_icons(sel[1])
              file_utils.move_path(plain)
              vim.schedule(function() fzf.files() end)
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
