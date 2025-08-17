-- Required mostly be lualine plugin
-- Copied from Lazyvim
local M = {
    icons = {
        misc = {
            dots = "󰇘",
            timer = "󰔟",
        },
        dap = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = " ",
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
        },
        diagnostics = { ERROR = " ", WARN = " ", HINT = " ", INFO = " " },
        git = { added = " ", modified = " ", removed = " " },
        kinds = {
            Array = " ",
            Boolean = "󰨙 ",
            Class = " ",
            Codeium = "󰘦 ",
            Color = " ",
            Control = " ",
            Collapsed = " ",
            Constant = "󰏿 ",
            Constructor = " ",
            Copilot = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = "󰈙 ",
            Folder = " ",
            Function = "󰡱 ",
            Interface = " ",
            Key = "󰌋 ",
            Keyword = " ",
            Method = "󰡱 ",
            Module = " ",
            Namespace = "󰦮 ",
            Null = "󰟢 ",
            Number = "󰎠 ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            Reference = " ",
            Snippet = " ",
            String = " ",
            Struct = " ",
            TabNine = "󰏚 ",
            Text = " ",
            TypeParameter = " ",
            Unit = " ",
            Value = " ",
            Variable = "󰀫 ",
        },
        -- Only to keep things in sync with "navbuddy"
        kind_lspsaga = {
            ["Array"] = { " ", "Type" },
            ["Boolean"] = { "󰨙 ", "Boolean" },
            ["Class"] = { " ", "Include" },
            ["Constant"] = { "󰏿 ", "Constant" },
            ["Constructor"] = { " ", "@constructor" },
            ["Enum"] = { " ", "@number" },
            ["EnumMember"] = { " ", "Number" },
            ["Event"] = { " ", "Constant" },
            ["Field"] = { " ", "@field" },
            ["File"] = { "󰈙 ", "Tag" },
            ["Function"] = { "󰡱 ", "Function" },
            ["Interface"] = { " ", "Type" },
            ["Key"] = { "󰌋 ", "Constant" },
            ["Method"] = { "󰡱 ", "Function" },
            ["Module"] = { " ", "Exception" },
            ["Namespace"] = { "󰦮 ", "Include" },
            ["Null"] = { "󰟢 ", "Constant" },
            ["Number"] = { "󰎠 ", "Number" },
            ["Object"] = { " ", "Type" },
            ["Operator"] = { " ", "Operator" },
            ["Package"] = { " ", "Label" },
            ["Property"] = { " ", "@property" },
            ["String"] = { " ", "String" },
            ["Struct"] = { " ", "Type" },
            ["TypeParameter"] = { " ", "Type" },
            ["Variable"] = { "󰀫 ", "@variable" },
            -- ccls
            ["TypeAlias"] = { " ", "Type" },
            ["Parameter"] = { " ", "@parameter" },
            ["StaticMethod"] = { "󰡱 ", "Function" },
            ["Macro"] = { " ", "Macro" },
            -- for completion sb microsoft!!!
            ["Text"] = { "󰭷 ", "String" },
            ["Snippet"] = { " ", "@variable" },
            ["Folder"] = { " ", "Title" },
            ["Unit"] = { "󰊱 ", "Number" },
            ["Value"] = { "󰀫 ", "@variable" },
        },
    },
}

function M.is_not_vscode()
    return not vim.g.vscode
end

function M.fg(name)
    ---@type {foreground?:number}?
    ---@diagnostic disable-next-line: deprecated
    local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
    ---@diagnostic disable-next-line: undefined-field
    local fg = hl and (hl.fg or hl.foreground)
    return fg and { fg = string.format("#%06x", fg) } or nil
end

---@param opts? lsp.Client.filter
function M.get_clients(opts)
    local ret = {} ---@type lsp.Client[]
    if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
    else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_active_clients(opts)
        if opts and opts.method then
            ---@param client lsp.Client
            ret = vim.tbl_filter(function(client)
                return client.supports_method(opts.method, { bufnr = opts.bufnr })
            end, ret)
        end
    end
    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param from string
---@param to string
function M.on_rename(from, to)
    local clients = M.get_clients()
    for _, client in ipairs(clients) do
        if client.supports_method("workspace/willRenameFiles") then
            ---@diagnostic disable-next-line: invisible
            local resp = client.request_sync("workspace/willRenameFiles", {
                files = {
                    {
                        oldUri = vim.uri_from_fname(from),
                        newUri = vim.uri_from_fname(to),
                    },
                },
            }, 1000, 0)
            if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
            end
        end
    end
end

---@param on_attach fun(client, buffer)
function M.on_lsp_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

return M
