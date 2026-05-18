local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- ─────────────────────────────────────────────
-- Window management
-- ─────────────────────────────────────────────

hl.bind(mainMod .. " + Q",          hl.dsp.window.close())
hl.bind(mainMod .. " + V", 			hl.dsp.window.float({ action = "toggle" }))

-- ─────────────────────────────────────────────
-- Session / lock / shutdown
-- ─────────────────────────────────────────────

hl.bind(mainMod .. " + L",
    hl.dsp.exec_cmd("hyprlock")
)

hl.bind(mainMod .. " + SHIFT + L",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"),
    { long_press = true, submap_universal = true, locked = true }
)

hl.bind(mainMod .. " + SHIFT + K",
    hl.dsp.exec_cmd("hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'"),
    { long_press = true, submap_universal = true, locked = true }
)

-- ─────────────────────────────────────────────
-- Application launchers
-- ─────────────────────────────────────────────

hl.bind(mainMod .. " + SHIFT + C",  hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + E",  hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + T",  hl.dsp.exec_cmd(textEditor))
hl.bind(mainMod .. " + SHIFT + M",  hl.dsp.exec_cmd(systemMonitor))
hl.bind(mainMod .. " + SPACE",      		hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + R",          hl.dsp.exec_cmd([[pypr menu "quickstart"]]))
hl.bind(mainMod .. " + ALT + G",    hl.dsp.exec_cmd([[pypr menu "games"]]))
hl.bind("Print",                    hl.dsp.exec_cmd("flameshot gui"))

-- ─────────────────────────────────────────────
-- Application shortcuts
-- ─────────────────────────────────────────────

-- Vestkop Mute
hl.bind("SUPER + ALT + M",
    hl.dsp.send_shortcut({ mods = "CONTROL_L + SHIFT", key = "M", window = "class:^(vesktop)$" })
)
-- Vesktop Deafen
hl.bind("SUPER + ALT + D",
    hl.dsp.send_shortcut({ mods = "CONTROL + SHIFT", key = "D", window = "class:^(vesktop)$" })
)

-- OBS passthrough
--hl.bind(
--    "SUPER + ALT + F1",
--    hl.dsp.pass({ class = "^(com\\.obsproject\\.Studio)$" })
--)

-- ─────────────────────────────────────────────
-- Focus movement
-- ─────────────────────────────────────────────

hl.bind(mainMod .. " + left",       hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",      hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",         hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",       hl.dsp.focus({ direction = "down" }))

-- ─────────────────────────────────────────────
-- Master layout
-- ─────────────────────────────────────────────

hl.bind("ALT + TAB",                       hl.dsp.layout("swapwithmaster"))
hl.bind(mainMod .. " + TAB",               hl.dsp.layout("rollnext"))
hl.bind(mainMod .. " + SHIFT + TAB",       hl.dsp.layout("rollprev"))

hl.bind(mainMod .. " + ALT + LEFT",        hl.dsp.layout("mfact +0.1"))
hl.bind(mainMod .. " + ALT + RIGHT",       hl.dsp.layout("mfact -0.1"))
hl.bind(mainMod .. " + ALT + UP",          hl.dsp.layout("mfact exact 0.5"))
hl.bind(mainMod .. " + ALT + DOWN",        hl.dsp.layout("mfact exact 0.55"))

-- ─────────────────────────────────────────────
-- Monitor / workspace navigation
-- ─────────────────────────────────────────────

local smw = hl.plugin.split_monitor_workspaces

hl.bind(mainMod .. " + next", function()
    return smw.change_monitor("next")
end)

hl.bind(mainMod .. " + prior", function()
    return smw.change_monitor("prev")
end)

for i = 1, 10 do
    local key = (i == 10) and "0" or tostring(i)

    hl.bind(mainMod .. " + " .. key, function()
        return smw.workspace(i)
    end)

    hl.bind(mainMod .. " + SHIFT + " .. key, function()
        return smw.move_to_workspace(i)
    end)
end

hl.bind(mainMod .. " + G",			hl.dsp.focus({ workspace = "name:gayming"}))
hl.bind(mainMod .. " + SHIFT + G",	hl.dsp.window.move({ workspace = "name:gayming", follow = yes }))

-- ─────────────────────────────────────────────
-- Special (scratchpad) workspaces
-- ─────────────────────────────────────────────

hl.bind(mainMod .. " + S",          hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S",  hl.dsp.window.move({ workspace = "special:magic", follow = yes }))

hl.bind(mainMod .. " + C",          hl.dsp.workspace.toggle_special("terminal"))
hl.bind(mainMod .. " + T",          hl.dsp.workspace.toggle_special("editor"))
hl.bind(mainMod .. " + E",          hl.dsp.workspace.toggle_special("filemanager"))
hl.bind(mainMod .. " + M",          hl.dsp.workspace.toggle_special("monitor"))

hl.bind(mainMod .. " + X",			hl.dsp.window.move({ workspace = "+0", follow = yes }))

-- ─────────────────────────────────────────────
-- Mouse move / resize (uncomment to enable)
-- ─────────────────────────────────────────────

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ─────────────────────────────────────────────
-- Standart Media Keys
-- ─────────────────────────────────────────────

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),       { locked = true })
