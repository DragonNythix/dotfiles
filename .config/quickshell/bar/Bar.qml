import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "widgets"

PanelWindow {
    id: bar

    // screen is set externally by shell.qml (QuickshellScreen)
    implicitHeight: 30
    color:          "#0f0f1a"

    anchors {
        top:   true
        left:  true
        right: true
    }

    // Match the QuickshellScreen back to a HyprlandMonitor by name so
    // WorkspaceBar can filter workspaces to the correct output.
    property var hyprMonitor: {
        for (let m of Hyprland.monitors.values) {
            if (m.name === bar.screen.name) return m
        }
        return null
    }

    // Three-zone layout: absolute anchoring keeps the clock truly centered
    // regardless of how wide the left/right sections are.
    Item {
        anchors.fill: parent

        // ── Left: workspaces ─────────────────────────────────────────
        ClockWidget {
            anchors {
                left:           parent.left
                leftMargin:     8
                verticalCenter: parent.verticalCenter
            }
        
        }
        // ── Center: clock ────────────────────────────────────────────
        WorkspaceBar {
            anchors.centerIn: parent
            hyprMonitor:      bar.hyprMonitor
        }
        // ── Right: audio + tray ──────────────────────────────────────
        RowLayout {
            anchors {
                right:          parent.right
                rightMargin:    8
                verticalCenter: parent.verticalCenter
            }
            spacing: 8

            SinkWidget       { panelWindow: bar }
            Rectangle {
                width: 1
                height: 16
                color: "#2a2a3a"
            }
            SourceWidget     { panelWindow: bar }
            Rectangle {
                width: 1
                height: 16
                color: "#2a2a3a"
            }
            SystemTrayWidget { panelWindow: bar }
        }
    }
}
