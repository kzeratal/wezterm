local wezterm = require("wezterm")
local act = wezterm.action

local mod = {}
mod.SUPER = "SUPER"
mod.SUPER_REV = "SUPER|CTRL"
mod.CTRL = "CTRL"
mod.OPT = "OPT"

local tab_color_list = {
    '#C47070', -- dusty red
    '#C4A060', -- dusty amber
    '#88A870', -- dusty olive
    '#60A898', -- dusty teal
    '#6888B8', -- dusty blue
    '#9070B0', -- dusty purple
    '#B87898', -- dusty pink
}

local function cycle_tab_color(window, offset)
    local tab_id = tostring(window:active_tab():tab_id())
    if not wezterm.GLOBAL.tab_color_index then
        wezterm.GLOBAL.tab_color_index = {}
    end
    if not wezterm.GLOBAL.tab_colors then
        wezterm.GLOBAL.tab_colors = {}
    end
    local n = #tab_color_list
    local idx = (wezterm.GLOBAL.tab_color_index[tab_id] or 0) + offset
    idx = idx % (n + 1)
    wezterm.GLOBAL.tab_color_index[tab_id] = idx
    wezterm.GLOBAL.tab_colors[tab_id] = tab_color_list[idx]
    -- force tab bar redraw by toggling a dummy override
    local overrides = window:get_config_overrides() or {}
    overrides._tab_color_tick = (overrides._tab_color_tick or 0) + 1
    window:set_config_overrides(overrides)
end

local spawn_tab_after_current = wezterm.action_callback(function(window, pane)
    local active_index = 0
    for _, info in ipairs(window:mux_window():tabs_with_info()) do
        if info.is_active then
            active_index = info.index
            break
        end
    end
    local _, new_pane = window:mux_window():spawn_tab({})
    window:perform_action(act.MoveTab(active_index + 1), new_pane)
end)

local keys_map = {{
    key = 'f',
    mods = mod.SUPER,
    action = act.Search({
        CaseInSensitiveString = ''
    })
}, {
    key = "c",
    mods = mod.SUPER,
    action = act.CopyTo("Clipboard")
}, {
    key = "v",
    mods = mod.SUPER,
    action = act.PasteFrom("Clipboard")
}, -- Tabs
{
    key = 't',
    mods = mod.SUPER,
    action = spawn_tab_after_current
}, {
    key = 'w',
    mods = mod.CTRL,
    action = act.CloseCurrentTab({
        confirm = false
    })
}, {
    key = 'LeftArrow',
    mods = mod.SUPER,
    action = act.ActivateTabRelative(-1)
}, {
    key = 'RightArrow',
    mods = mod.SUPER,
    action = act.ActivateTabRelative(1)
}, {
    key = 'LeftArrow',
    mods = 'OPT|SHIFT',
    action = act.MoveTabRelative(-1)
}, {
    key = 'RightArrow',
    mods = 'OPT|SHIFT',
    action = act.MoveTabRelative(1)
}, {
    key = 'UpArrow',
    mods = 'OPT|SHIFT',
    action = wezterm.action_callback(function(window, pane)
        cycle_tab_color(window, 1)
    end)
}, {
    key = 'DownArrow',
    mods = 'OPT|SHIFT',
    action = wezterm.action_callback(function(window, pane)
        cycle_tab_color(window, -1)
    end)
}, -- Panel
{
    key = '-',
    mods = mod.CTRL,
    action = act.SplitVertical({
        domain = "CurrentPaneDomain"
    })
}, {
    key = "\\",
    mods = mod.CTRL,
    action = act.SplitHorizontal({
        domain = "CurrentPaneDomain"
    })
}, -- Window?
{
    key = "n",
    mods = mod.CTRL,
    action = act.SpawnWindow
}}

local mouse_bindings = {{
    event = {
        Up = {
            streak = 1,
            button = "Left"
        }
    },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor
}, {
    event = {
        Up = {
            streak = 2,
            button = "Left"
        }
    },
    mods = "NONE",
    action = act.EmitEvent('toggle-maximize')
}}

return {
    disable_default_key_bindings = false,
    leader = {
        key = "Space",
        mods = mod.SUPER_REV
    },
    keys = keys_map,
    mouse_bindings = mouse_bindings
}
