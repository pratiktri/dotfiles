local wezterm = require("wezterm")

return {
    color_scheme = "Catppuccin Mocha",
    font_size = 14.0,
    font = wezterm.font_with_fallback({
        "JetBrainsMono Nerd Font",
        { family = "Symbols Nerd Font Mono", scale = 0.75 },
    }),
    window_decorations = "RESIZE",
    enable_tab_bar = true,
    use_fancy_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    win32_system_backdrop = "Mica",
    macos_window_background_blur = 80,

    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    keys = {
        {
            key = "f",
            mods = "ALT",
            action = wezterm.action.ToggleFullScreen,
        },
    },

    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },

    force_reverse_video_cursor = true,
    colors = {
        foreground = "#dcd7ba",
        background = "#1f1f28",

        cursor_bg = "#c8c093",
        cursor_fg = "#c8c093",
        cursor_border = "#c8c093",

        selection_fg = "#c8c093",
        selection_bg = "#2d4f67",

        scrollbar_thumb = "#16161d",
        split = "#16161d",

        ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
        brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
        indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
    },
}
