return {
    {
        "mfussenegger/nvim-lint",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            -- Linters are only required for dynamically typed languages
            lint.linters_by_ft = {
                -- javascript = { "eslint_d" },
                -- typescript = { "eslint_d" },
                -- javascriptreact = { "eslint_d" },
                -- typescriptreact = { "eslint_d" },
                svelte = { "eslint_d" },
                python = { "pylint" },
                ["*"] = { "codespell" },
            }

            -- Uncomment and use the below section in `package.json` to enable eslint_d
            -- "eslintConfig": {
            --     "root": true,
            --     "extends": [
            --         "eslint:recommended",
            --         "plugin:@typescript-eslint/recommended"
            --     ],
            --     "parser": "@typescript-eslint/parser",
            --     "parserOptions": {
            --         "project": [
            --             "./tsconfig.json"
            --         ]
            --     },
            --     "plugins": [
            --         "@typescript-eslint"
            --     ],
            --     "rules": {
            --         "@typescript-eslint/strict-boolean-expressions": [
            --             2,
            --             {
            --                 "allowString": false,
            --                 "allowNumber": false
            --             }
            --         ]
            --     },
            --     "ignorePatterns": [
            --         "src/**/*.test.ts",
            --         "src/frontend/generated/*"
            --     ]
            -- }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
