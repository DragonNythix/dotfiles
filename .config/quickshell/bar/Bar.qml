pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "widgets"
import "util"

PanelWindow {
    id: bar

    required property var  hyprMonitor
    required property real borderThickness

    anchors { top: true; left: true; right: true }

    // The PanelWindow grows to include the border strip so its exclusive zone
    // automatically reserves the right amount of space at the top of the screen.
    implicitHeight: 30 + bar.borderThickness
    color:          '#040316'

    // ── Content layer — shifted down by borderThickness ───────────────
    // The bar background fills the full PanelWindow height (so the color
    // bleeds into the border strip area), but all interactive widgets sit
    // below the border strip at their natural vertical center.
    Item {
        anchors {
            fill:       parent
            topMargin:  bar.borderThickness
        }

        // ── Left: clock ──────────────────────────────────────────────
        ClockWidget {
            anchors {
                left:           parent.left
                leftMargin:     10
                verticalCenter: parent.verticalCenter
            }
        }

        // ── Center: workspaces ───────────────────────────────────────
        WorkspaceBar {
            anchors.centerIn: parent
            hyprMonitor:      bar.hyprMonitor
            borderThickness:  bar.borderThickness
        }

        // ── Right: audio + tray ──────────────────────────────────────
        RowLayout {
            anchors {
                right:          parent.right
                rightMargin:   10
                verticalCenter: parent.verticalCenter
            }
            spacing: 8


            Devider{}
            SystemTrayWidget { panelWindow: bar }
        }
    }
}
