//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "bar"
import "border"

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Scope {
            id: perScreen
            required property ShellScreen modelData

            // ── Match screen → HyprlandMonitor ───────────────────────
            property var hyprMonitor: {
                for (let m of Hyprland.monitors.values)
                    if (m.name === perScreen.modelData.name) return m
                return null
            }

            // ── Border thickness: 6 if windows present, 12 if empty ──
            // Checks the active workspace on this monitor only.
            property int borderThickness: {
                let mon = perScreen.hyprMonitor
                if (!mon) return 0
                for (let ws of Hyprland.workspaces.values)
                    if (ws.monitor === mon && ws.active)
                        return ws.toplevels.values.length > 0 ? 6 : 12
                return 10
            }

            // Smooth slide between 0 and 12
            Behavior on borderThickness {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            Bar {
                screen:          perScreen.modelData
                hyprMonitor:     perScreen.hyprMonitor
                borderThickness: perScreen.borderThickness
            }

            Border {
                screen:          perScreen.modelData
                borderThickness: perScreen.borderThickness
                barHeight:       30 + perScreen.borderThickness
            }

            Exclusions {
                screen:          perScreen.modelData
                borderThickness: perScreen.borderThickness
            }
        }
    }
}
