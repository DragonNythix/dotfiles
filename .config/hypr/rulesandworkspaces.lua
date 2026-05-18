--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.layer_rule({
	name = "vicinae-rules",
	match =  { namespace = "vicinae" },
	no_anim = true,
})

hl.window_rule({
  name = "bitwarden-float",
  match = {
    class = "firefox",
    title = ".*Bitwarden.*" 
  },
})

-- special workspace
hl.workspace_rule({
	workspace = "special:magic",
	layout = "dwindle",
	gaps_in = 0,
})

-- gaming workspace
hl.workspace_rule({
	workspace = "name:gayming",
	monitor = "DP-1",
	no_border = true,
	no_shadow = true,
	no_rounding = true,
	decorate = false,
	persistent = false,
	on_created_empty = "pypr menu games"
})

hl.workspace_rule({ workspace = "special:terminal", on_created_empty = terminal })
hl.window_rule({
  name = "no-window-terminal",
  match = {
    class = ".*[^kitty].*",
    workspace = "special:terminal"
  },
  workspace = "+0"
})

hl.workspace_rule({ workspace = "special:filemanager", on_created_empty = fileManager })
hl.window_rule({
  name = "no-window-filemanager",
  match = {
    title = ".*[^yazi].*",
    workspace = "special:filemanager"
  },
  workspace = "+0"
})

hl.workspace_rule({ workspace = "special:editor", on_created_empty = textEditor })
hl.window_rule({
  name = "no-window-editor",
  match = {
    title = ".*[^micro].*",
    workspace = "special:editor"
  },
  workspace = "+0"
})
hl.workspace_rule({ workspace = "special:monitor", on_created_empty = systemMonitor })
hl.window_rule({
  name = "no-window-monitor",
  match = {
    title = ".*[^btop].*",
    workspace = "special:monitor"
  },
  workspace = "+0"
})
