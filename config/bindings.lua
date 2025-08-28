local wezterm = require("wezterm")
local act = wezterm.action

local mod = {}
mod.SUPER = "SUPER"
mod.SUPER_REV = "SUPER|CTRL"
mod.CTRL = "CTRL"
mod.OPT = "OPT"

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
    mods = mod.CTRL,
    action = act.SpawnTab("DefaultDomain")
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
    disable_default_key_bindings = true,
    leader = {
        key = "Space",
        mods = mod.SUPER_REV
    },
    keys = keys_map,
    mouse_bindings = mouse_bindings
}
