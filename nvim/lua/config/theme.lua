local ayu = require("ayu")

vim.g.ayu_theme = "dark" -- atau light, mirage

ayu.setup {
    overrides = {
        TSAnnotation = { fg = "#FFB454" },
        TSAttribute = { fg = "#5CCFE6" },
        TSBoolean = { fg = "#FFB454" },
        TSCharacter = { fg = "#C2D94C" },
        TSComment = { fg = "#5C6773" },
        TSConditional = { fg = "#FF8F40" },
        TSConstant = { fg = "#FFEE99" },
        TSConstructor = { fg = "#FFB454" },
        TSError = { fg = "#FF3333" },
        TSException = { fg = "#FF8F40" },
        TSField = { fg = "#5CCFE6" },
        TSFloat = { fg = "#FFB454" },
        TSFunction = { fg = "#FFB454" },
        TSIdentifier = { fg = "#E6E6E6" },
        TSInclude = { fg = "#FF8F40" },
        TSKeyword = { fg = "#FF8F40" },
        TSLabel = { fg = "#FFB454" },
        TSMethod = { fg = "#FFB454" },
        TSNamespace = { fg = "#5CCFE6" },
        TSNumber = { fg = "#FFB454" },
        TSOperator = { fg = "#F29668" },
        TSParameter = { fg = "#E6E6E6" },
        TSProperty = { fg = "#5CCFE6" },
        TSPunctBracket = { fg = "#BFBDB6" },
        TSPunctDelimiter = { fg = "#BFBDB6" },
        TSPunctSpecial = { fg = "#FFB454" },
        TSRepeat = { fg = "#FF8F40" },
        TSString = { fg = "#C2D94C" },
        TSStructure = { fg = "#36A3D9" },
        TSType = { fg = "#36A3D9" },
        TSTypeBuiltin = { fg = "#36A3D9" },
        TSVariable = { fg = "#E6E6E6" },
    }
}

vim.cmd.colorscheme("ayu")
