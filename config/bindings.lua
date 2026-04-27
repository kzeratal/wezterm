local wezterm = require("wezterm")
local act = wezterm.action

local mod = {}
mod.SUPER = "SUPER"
mod.SUPER_REV = "SUPER|CTRL"
mod.CTRL = "CTRL"
mod.OPT = "OPT"

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
