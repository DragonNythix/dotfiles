import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: root

    // ── Tunables ──────────────────────────────────────────────────────
    property int   borderThickness: 6
    property int   borderRounding:  14
    property color borderColor:     "#1a1a2e"

    // ── Layer shell setup ─────────────────────────────────────────────
    // Overlay sits above all normal windows; no exclusive zone so the
    // compositor doesn't shrink the usable area for this window.
    WlrLayershell.layer:                WlrLayer.Overlay
    WlrLayershell.keyboardInteractivity: WlrKeyboardInteractivity.None
    exclusiveZone: -1   // -1 = don't reserve any space

    // Anchor all four edges so the window fills the entire screen
    anchors { top: true; bottom: true; left: true; right: true }

    // The window itself is transparent — the colored rectangle below
    // is the only thing drawn, and the mask punches out its center.
    color: "transparent"

    // ── Border rectangle (full-screen, color-filled) ──────────────────
    Rectangle {
        id: borderRect
        anchors.fill: parent
        color:        root.borderColor

        // The MultiEffect uses an inverted mask: the mask item defines
        // the "hole" to cut out, so only the thin border strip remains.
        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource:       mask
            maskEnabled:      true
            maskInverted:     true
            maskThresholdMin: 0.5
            maskSpreadAtMin:  1.0
        }
    }

    // ── Mask — defines the area to REMOVE from borderRect ────────────
    // A rounded rectangle inset by borderThickness on all sides.
    // Everything inside it gets cut away; everything outside stays.
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false          // only used as a mask source, never rendered directly

        Rectangle {
            anchors {
                fill:        parent
                margins:     root.borderThickness
            }
            radius: root.borderRounding
        }
    }
}
