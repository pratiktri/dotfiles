return {
    cmd = { "omnisharp" },
    handlers = {
        ["textDocument/definition"] = function(...)
            return require("omnisharp_extended").handler(...)
        end,
    },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    enable_editorconfig_support = true,
    enable_ms_build_load_projects_on_demand = false,
    analyze_open_documents_only = false,
    settings = {
        dotnet = {
            server = {
                useOmnisharpServer = true,
                useModernNet = true,
            },
        },
        csharp = {
            inlayHints = {
                parameters = {
                    enabled = true,
                },
                types = {
                    enabled = true,
                },
            },
        },
    },
}
