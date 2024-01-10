return {
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                text = { "vale" },
                json = { "jsonlint" },
                markdown = { "markdownlint", "vale" },
                rst = { "vale" },
                dockerfile = { "hadolint" },
                go = { "golangcilint" },
                jq = { "jq" },
                bash = { "shellcheck" },
                shell = { "shellcheck" },
                yaml = { "yamllint" },
                zsh = { "zsh" },
                typescript = { "eslint_d" },
                javascript = { "eslint_d" },
                -- Use the "*" filetype to run linters on all filetypes.
                -- ['*'] = { 'global linter' },
                -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
                -- ['_'] = { 'fallback linter' },
            },
        },
    },
}
