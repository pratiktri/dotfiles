return {
    -- Test runner integration
    -- Taken from LazyVim
    {
        "nvim-neotest/neotest",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",

            "marilari88/neotest-vitest", -- JS/TS/React/Vue
            "rcasia/neotest-bash", -- bash
        },
        opts = {
            -- Do NOT add adapters here
            -- Add it to opts.adapters inside config function below
            adapters = {},
            status = { virtual_text = true },
            output = { open_on_run = true },
            quickfix = {
                open = function()
                    if require("lazy.core.config").spec.plugins["trouble.nvim"] ~= nil then
                        require("trouble").open({ mode = "quickfix", focus = false })
                    else
                        vim.cmd("copen")
                    end
                end,
            },
        },
        config = function(_, opts)
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- Replace newline and tab characters with space for more compact diagnostics
                        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, neotest_ns)

            if require("lazy.core.config").spec.plugins["trouble.nvim"] ~= nil then
                opts.consumers = opts.consumers or {}
                -- Refresh and auto close trouble after running tests
                ---@type neotest.Consumer
                opts.consumers.trouble = function(client)
                    client.listeners.results = function(adapter_id, results, partial)
                        if partial then
                            return
                        end
                        local tree = assert(client:get_position(nil, { adapter = adapter_id }))

                        local failed = 0
                        for pos_id, result in pairs(results) do
                            if result.status == "failed" and tree:get_key(pos_id) then
                                failed = failed + 1
                            end
                        end
                        vim.schedule(function()
                            local trouble = require("trouble")
                            if trouble.is_open() then
                                trouble.refresh()
                                if failed == 0 then
                                    trouble.close()
                                end
                            end
                        end)
                        return {}
                    end
                end
            end

            -- TIP: Add adapters here
            table.insert(opts.adapters, require("neotest-vitest"))
            table.insert(opts.adapters, require("rustaceanvim.neotest"))

            if opts.adapters then
                local adapters = {}
                for name, config in pairs(opts.adapters or {}) do
                    if type(name) == "number" then
                        if type(config) == "string" then
                            config = require(config)
                        end
                        adapters[#adapters + 1] = config
                    elseif config ~= false then
                        local adapter = require(name)
                        if type(config) == "table" and not vim.tbl_isempty(config) then
                            local meta = getmetatable(adapter)
                            if adapter.setup then
                                adapter.setup(config)
                            elseif meta and meta.__call then
                                adapter(config)
                            else
                                error("Adapter " .. name .. " does not support setup")
                            end
                        end
                        adapters[#adapters + 1] = adapter
                    end
                end
                opts.adapters = adapters
            end

            require("neotest").setup(opts)
        end,
        -- stylua: ignore
        keys = {
            -- TIP: Shortcuts in test summary window:
            --  r: Run the selected test
            --  a: Attaches to the test result (output)
            --  i: Jumps to the code of the test
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Test: Run All Test in Current File" },
            { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end,                          desc = "Test: Run All Test Files" },
            { "<leader>tn", function() require("neotest").run.run() end,                                        desc = "Test: Run Nearest" },
            { "<leader>tR", function() require("neotest").run.run_last() end,                                   desc = "Test: Re-Run Last" },
            { "<leader>ts", function() require("neotest").run.stop() end,                                       desc = "Test: Stop" },

            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test: Show Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Test: Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").summary.toggle() end,                                 desc = "Test: Toggle Summary Panel" },
        },
    },
}
