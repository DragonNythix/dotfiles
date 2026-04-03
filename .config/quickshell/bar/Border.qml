pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

// Visual-only fullscreen overlay. No input region (mask: Region {}) so all
// clicks fall through to whatever is beneath it on the compositor stack.
PanelWindow {
    id: root

    required property ShellScreen screen

    property int   borderThickness: 10
    property int   borderRounding:  20
    property color borderColor:     '#0f0f1a'

    // Sit above all normal windows
    WlrLayershell.layer: WlrLayer.Overlay

    // -1 = do not reserve any compositor space; purely decorative
    exclusiveZone: -1

    // Empty input region — the window is fully click-through
    mask: Region {}

    // Fill the whole screen
    anchors { top: true; bottom: true; left: true; right: true }

    color: "transparent"

    // ── Colored rectangle that will be masked ──────────────────────────
    Rectangle {
        anchors.fill: parent
        color: root.borderColor

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource:       mask
            maskEnabled:      true
            maskInverted:     true   // keep the OUTSIDE of the cutout, not the inside
            maskThresholdMin: 0.5
            maskSpreadAtMin:  1.0
        }
    }

    // ── Mask — the hole to punch through the rectangle ────────────────
    // Inset by borderThickness on all sides; everything inside is removed.
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors {
                fill:    parent
                margins: root.borderThickness
            }
            radius: root.borderRounding
        }
    }
}
