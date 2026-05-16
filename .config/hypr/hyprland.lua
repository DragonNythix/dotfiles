-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/
 
------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@164",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "DP-3",
    mode     = "2560x1440@60",
    position = "2560x0",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

terminal      = "kitty"
fileManager   = "kitty  --title yazi yazi"
menu          = "vicinae toggle"
textEditor    = "kitty --title micro micro "
systemMonitor = "kitty --title btop btop "


-------------------
---- AUTOSTART ----
-------------------

require("autostarts")


-- ENVIRONMENT VARIABLES
hl.env("HYPRCURSOR_THEME", "theme_HackneyedCursors")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")

hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME", "nvidia")


-- LOOK AND FEEL
require("lookandfeel")


-- INPUT
hl.config({
    input = {
        kb_layout = "de",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        numlock_by_default = true,

        follow_mouse = 1,

        sensitivity = 0,

    },
})


-- KEYBINDS
require("keybinds")



-- RULES / WORKSPACES
require("rulesandworkspaces")

-- Example lua config
hl.config({
    plugin = {
        split_monitor_workspaces = {
            count                        = 10,
            keep_focused                 = 1,
            enable_notifications         = 0,
            enable_persistent_workspaces = 1,
            enable_wrapping              = 0,
            link_monitors                = 0,
        },
    },
})
