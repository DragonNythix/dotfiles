import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: root
    required property var screen

    anchors { top: true; bottom: true; left: true; right: true }
    exclusiveZone: -1
    aboveWindows: true
    color: "transparent"

    // Empty region = zero input capture; all clicks fall through to windows
    mask: Region { }

    // ── Tunables ─────────────────────────────────────────────────────────────
    readonly property int thickness: 2   // border width in px
    readonly property int rounding:  18  // corner radius — match your monitor's physical corners

    // ── How it works ─────────────────────────────────────────────────────────
    // Rather than stroking a path, we fill the entire screen with the border
    // colour and punch a rounded hole through it using an inverted mask.
    // The hole is inset by `thickness` on every side, so only the rim remains.
    // This approach needs no arc math and handles any corner radius cleanly.

    Rectangle {
        anchors.fill: parent
        color: "#5B4CA2"

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource:       innerMask
            maskEnabled:      true
            maskInverted:     true
            maskThresholdMin: 0.5
            maskSpreadAtMin:  1
        }
    }

    // The mask shape — the area that gets *removed* from the rectangle above.
    // Inset by thickness and rounded, so what remains is just the border rim.
    Item {
        id: innerMask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill:    parent
            anchors.margins: root.thickness
            radius:          root.rounding
        }
    }
}
