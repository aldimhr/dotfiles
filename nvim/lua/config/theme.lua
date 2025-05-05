local ayu = require("ayu")

ayu.setup({
    mirage = false, -- dark mode
    overrides = {
        -- literal & konstanta (gruvbox yellow)
        Constant                    = { fg = "#fabd2f" },
        Number                      = { fg = "#fabd2f" },
        Boolean                     = { fg = "#fabd2f" },
        Float                       = { fg = "#fabd2f" },

        -- string & character (gruvbox green)
        String                      = { fg = "#b8bb26" },
        Character                   = { fg = "#b8bb26" },

        -- identifier / variable / parameter (gruvbox aqua)
        Identifier                  = { fg = "#8ec07c" },
        Variable                    = { fg = "#8ec07c" },
        Parameter                   = { fg = "#8ec07c" },

        -- keyword / control flow / label / exception (gruvbox red)
        Keyword                     = { fg = "#fb4934" },
        Statement                   = { fg = "#fb4934" },
        Conditional                 = { fg = "#fb4934" },
        Repeat                      = { fg = "#fb4934" },
        Label                       = { fg = "#fb4934" },
        Exception                   = { fg = "#fb4934" },

        -- function / method / constructor (gruvbox blue)
        Function                    = { fg = "#83a598" },
        Method                      = { fg = "#83a598" },
        Constructor                 = { fg = "#83a598" },

        -- type / struct / storageClass / typedef (gruvbox purple)
        Type                        = { fg = "#d3869b" },
        StorageClass                = { fg = "#d3869b" },
        Structure                   = { fg = "#d3869b" },
        Typedef                     = { fg = "#d3869b" },

        -- preprocessor / include / define / macro (gruvbox orange)
        PreProc                     = { fg = "#fe8019" },
        Include                     = { fg = "#fe8019" },
        Define                      = { fg = "#fe8019" },
        Macro                       = { fg = "#fe8019" },

        -- operator (gruvbox fg) & punctuation (gruvbox gray)
        Operator                    = { fg = "#ebdbb2" },
        Punctuation                 = { fg = "#928374" },
        Delimiter                   = { fg = "#928374" },

        -- komentar (gruvbox gray)
        Comment                     = { fg = "#928374", italic = true },
        SpecialComment              = { fg = "#928374", italic = true },

        -- underlined, error, todo
        Underlined                  = { underline = true, fg = "#fb4934" },
        Error                       = { fg = "#fb4934", bold = true },
        Todo                        = { fg = "#fe8019", bg = "#3c3836", bold = true },

        -- Diff text
        DiffAdd                     = { fg = "#b8bb26", bg = "#1f1f0f" },
        DiffChange                  = { fg = "#fabd2f", bg = "#1f1e1b" },
        DiffDelete                  = { fg = "#fb4934", bg = "#3c1f1f" },
        DiffText                    = { fg = "#ebdbb2", bg = "#3a3a3a" },

        -- Spell
        SpellBad                    = { undercurl = true, sp = "#fb4934" },
        SpellCap                    = { undercurl = true, sp = "#fabd2f" },
        SpellLocal                  = { undercurl = true, sp = "#b8bb26" },
        SpellRare                   = { undercurl = true, sp = "#83a598" },

        -- Tree-sitter Highlights
        ["@constant"]               = { fg = "#fabd2f" },
        ["@number"]                 = { fg = "#fabd2f" },
        ["@boolean"]                = { fg = "#fabd2f" },
        ["@float"]                  = { fg = "#fabd2f" },

        ["@string"]                 = { fg = "#b8bb26" },
        ["@character"]              = { fg = "#b8bb26" },

        ["@identifier"]             = { fg = "#8ec07c" },
        ["@variable"]               = { fg = "#8ec07c" },
        ["@parameter"]              = { fg = "#8ec07c" },

        ["@keyword"]                = { fg = "#fb4934" },
        ["@conditional"]            = { fg = "#fb4934" },
        ["@repeat"]                 = { fg = "#fb4934" },
        ["@exception"]              = { fg = "#fb4934" },

        ["@function"]               = { fg = "#83a598" },
        ["@method"]                 = { fg = "#83a598" },
        ["@constructor"]            = { fg = "#83a598" },

        ["@type"]                   = { fg = "#d3869b" },
        ["@type.builtin"]           = { fg = "#d3869b" },
        ["@structure"]              = { fg = "#d3869b" },

        ["@operator"]               = { fg = "#ebdbb2" },
        ["@punctuation.bracket"]    = { fg = "#928374" },
        ["@punctuation.delimiter"]  = { fg = "#928374" },
        ["@punctuation.special"]    = { fg = "#928374" },
        ["@tag"]                    = { fg = "#fb4934" },

        ["@label"]                  = { fg = "#fb4934" },

        -- LSP Semantic Tokens
        ["@lsp.type.class"]         = { fg = "#d3869b" },
        ["@lsp.type.comment"]       = { fg = "#928374", italic = true },
        ["@lsp.type.enum"]          = { fg = "#d3869b" },
        ["@lsp.type.enumMember"]    = { fg = "#fabd2f" },
        ["@lsp.type.event"]         = { fg = "#fb4934" },
        ["@lsp.type.function"]      = { fg = "#83a598" },
        ["@lsp.type.interface"]     = { fg = "#d3869b" },
        ["@lsp.type.keyword"]       = { fg = "#fb4934" },
        ["@lsp.type.macro"]         = { fg = "#fe8019" },
        ["@lsp.type.method"]        = { fg = "#83a598" },
        ["@lsp.type.modifier"]      = { fg = "#fb4934" },
        ["@lsp.type.namespace"]     = { fg = "#ebdbb2" },
        ["@lsp.type.number"]        = { fg = "#fabd2f" },
        ["@lsp.type.operator"]      = { fg = "#ebdbb2" },
        ["@lsp.type.parameter"]     = { fg = "#ebdbb2" },
        ["@lsp.type.property"]      = { fg = "#ebdbb2" },
        ["@lsp.type.regexp"]        = { fg = "#b8bb26" },
        ["@lsp.type.string"]        = { fg = "#b8bb26" },
        ["@lsp.type.struct"]        = { fg = "#d3869b" },
        ["@lsp.type.type"]          = { fg = "#d3869b" },
        ["@lsp.type.typeParameter"] = { fg = "#d3869b" },
        ["@lsp.type.variable"]      = { fg = "#ebdbb2" },
    },
})

vim.cmd.colorscheme("ayu")
