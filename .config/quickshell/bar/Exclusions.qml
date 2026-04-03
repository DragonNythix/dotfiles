pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland

// Four invisible 1×1 PanelWindows — one per screen edge — that claim exclusive
// zones so the compositor pushes application windows away from the border strip.
//
// The top edge is intentionally omitted here: the bar's own PanelWindow already
// claims its exclusive zone on that edge. Adding another zone would double-count
// and push windows down too far.
Scope {
    id: root

    required property ShellScreen screen
    required property int         borderThickness

    // Left edge
    ExclusionZone { anchors.left: true }

    // Right edge
    ExclusionZone { anchors.right: true }

    // Bottom edge
    ExclusionZone { anchors.bottom: true }

    // ── Shared invisible-window template ───────────────────────────────
    component ExclusionZone: PanelWindow {
        screen:         root.screen
        exclusiveZone:  root.borderThickness
        mask:           Region {}   // no input region → fully click-through
        color:          "transparent"
        implicitWidth:  1
        implicitHeight: 1
    }
}
