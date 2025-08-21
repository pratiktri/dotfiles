if pcall(require, "rustaceanvim") then
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set("n", "gC", "<cmd>RustLsp openCargo<cr>", { desc = "Open Cargo.toml", buffer = bufnr })
    vim.keymap.set("n", "<leader>rm", "<cmd>RustLsp expandMacro<cr>", { desc = "Expand Macro", buffer = bufnr })
    vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>", { desc = "Parent Module", buffer = bufnr })
    vim.keymap.set("n", "<leader>rJ", "<cmd>RustLsp joinLines<cr>", { desc = "Join Lines", buffer = bufnr })
    vim.keymap.set("n", "<leader>rh", "<cmd>RustLsp openDocs<cr>", { desc = "Open docs.rs Documentation" })
    vim.keymap.set("n", "<leader>rM", "<cmd>RustLsp view mir<cr>", { desc = "View Mid-Level IR", buffer = bufnr })
    vim.keymap.set("n", "<leader>rH", "<cmd>RustLsp view hir<cr>", { desc = "View High-Level IR", buffer = bufnr })
    vim.keymap.set("n", "<leader>rL", vim.lsp.codelens.refresh, { desc = "Run CodeLens" })
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or client.name ~= "rust-analyzer" then
            return
        end

        pcall(vim.lsp.codelens.refresh)

        -- Setup ongoing refresh triggers
        vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "BufEnter" }, {
            buffer = event.buf,
            callback = vim.lsp.codelens.refresh,
        })
    end,
})

local function run_tests_with_coverage()
    -- Run tests through neotest
    require("neotest").run.run(vim.fn.expand("%"))

    -- Generate coverage after tests complete
    vim.fn.jobstart("cargo llvm-cov --lcov --output-path coverage.lcov", {
        on_exit = function(_, code)
            if code == 0 then
                -- Load coverage data
                require("coverage").load(true)
                print("Coverage updated")
            else
                print("Coverage generation failed")
            end
        end,
    })
end

vim.keymap.set("n", "<leader>tc", run_tests_with_coverage, { desc = "Test: Run tests with coverage" })
