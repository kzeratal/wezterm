local wezterm = require("wezterm")

function get_max_cols(window)
  local tab = window:active_tab()
  local cols = tab:get_size().cols
  return cols
end

wezterm.on(
  'window-config-reloaded',
  function(window)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on(
  'window-resized',
  function(window, pane)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = tab.active_pane.title
    local tab_number = '[' .. tab.tab_index + 1 .. '] '
    
    -- Chrome-like behavior: minimum width with ellipsis for long titles
    local min_width = 20
    local available_width = math.max(min_width, max_width)
    local title_width = available_width - #tab_number - 2 -- 2 for padding
    
    if #title > title_width then
      title = title:sub(1, title_width - 1) .. '…'
    end
    
    local full_title = tab_number .. title
    local padding = math.max(0, (available_width - #full_title) // 2)
    
    return string.rep(' ', padding) .. full_title .. string.rep(' ', padding)
  end
)

wezterm.on('toggle-maximize', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.window_maximized = true
  window:set_config_overrides(overrides)
end)

return {
    term = "xterm-256color",
    animation_fps = 60,
    max_fps = 60,

    window_background_opacity = 1.00,

    enable_scroll_bar = true,
    min_scroll_bar_height = "3cell",
    colors = {
        foreground = "#DCD7BA",
        background = "#1F1F28",
        
        cursor_bg = "#E46876",
        cursor_fg = "#1F1F28",
        cursor_border = "#E46876",
        
        selection_fg = "#DCD7BA",
        selection_bg = "#223249",
        
        scrollbar_thumb = "#363646",
        
        ansi = {
            "#16161D", -- black
            "#E82424", -- red
            "#76946A", -- green
            "#DCA561", -- yellow
            "#7E9CD8", -- blue
            "#957FB8", -- magenta
            "#7AA89F", -- cyan
            "#DCD7BA", -- white
        },
        brights = {
            "#727169", -- bright black
            "#E82424", -- bright red
            "#76946A", -- bright green
            "#DCA561", -- bright yellow
            "#7E9CD8", -- bright blue
            "#957FB8", -- bright magenta
            "#7AA89F", -- bright cyan
            "#DCD7BA", -- bright white
        },
        
        tab_bar = {
            background = "#16161D",
            active_tab = {
                bg_color = "#1F1F28",
                fg_color = "#C8C093",
            },
            inactive_tab = {
                bg_color = "#2A2A37",
                fg_color = "#DCD7BA",
            },
            inactive_tab_hover = {
                bg_color = "#363646",
                fg_color = "#DCD7BA",
            },
            new_tab = {
                bg_color = "#16161D",
                fg_color = "#727169",
            },
            new_tab_hover = {
                bg_color = "#363646",
                fg_color = "#DCD7BA",
            },
        },
    },

    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    use_fancy_tab_bar = true,
    show_new_tab_button_in_tab_bar = false,
    tab_max_width = 32,
    show_tab_index_in_tab_bar = true,
    switch_to_last_active_tab_when_closing_tab = true,

    default_cursor_style = "BlinkingBlock",
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
    cursor_blink_rate = 500,

    adjust_window_size_when_changing_font_size = false,
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    initial_cols = 120,
    initial_rows = 48,
    window_close_confirmation = "AlwaysPrompt"
}
