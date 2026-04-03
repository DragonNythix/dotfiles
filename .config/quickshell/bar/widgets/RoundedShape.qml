import QtQuick
import QtQuick.Shapes

// Reusable rounded rectangle shape with per-corner control.
//
// Every corner can be individually radiused and optionally inverted (concave).
// Inverted corners curve inward rather than outward, useful for popups that
// "grow out of" a parent surface (e.g. a popup appearing below a bar widget).
//
// Usage:
//   RoundedShape {
//       anchors.fill: parent
//       fillColor:   "#010101"
//       strokeColor: "#5B4CA2"
//       strokeWidth: 1
//       radius: 8                // shorthand sets all four corners
//       topLeftRadius:  12       // override individual corners
//       invertTopLeft:  true     // concave top-left corner
//       invertTopRight: true     // concave top-right corner
//   }

Shape {
    id: root

    // ── Shorthand — sets all four corners; overridden per-corner below ──────
    property real radius: 8

    // ── Per-corner radii ────────────────────────────────────────────────────
    property real topLeftRadius:     radius
    property real topRightRadius:    radius
    property real bottomRightRadius: radius
    property real bottomLeftRadius:  radius

    // ── Per-corner inversion (concave / bite-in) ────────────────────────────
    property bool invertTopLeft:     false
    property bool invertTopRight:    false
    property bool invertBottomRight: false
    property bool invertBottomLeft:  false

    // ── Visuals ─────────────────────────────────────────────────────────────
    property color fillColor:   "transparent"
    property color strokeColor: "transparent"
    property real  strokeWidth: 1

    // ─────────────────────────────────────────────────────────────────────────
    // How it works:
    //
    // For each corner the path visits the same entry/exit points regardless of
    // inversion — only the arc direction changes:
    //
    //   Normal (convex):   PathArc.Clockwise        → curves outward
    //   Inverted (concave):PathArc.Counterclockwise → curves inward
    //
    // Corner entry → exit points (all radii = r, width = w, height = h):
    //   Top-left:     (0, tlr)   → (tlr, 0)
    //   Top-right:    (w-trr, 0) → (w, trr)
    //   Bottom-right: (w, h-brr) → (w-brr, h)
    //   Bottom-left:  (blr, h)   → (0, h-blr)
    // ─────────────────────────────────────────────────────────────────────────

    ShapePath {
        fillColor:   root.fillColor
        strokeColor: root.strokeWidth > 0 ? root.strokeColor : "transparent"
        strokeWidth: root.strokeWidth > 0 ? root.strokeWidth : -1

        // Start at the exit point of the top-left corner (beginning of top edge)
        startX: root.topLeftRadius
        startY: 0

        // ── Top edge ────────────────────────────────────────────────────────
        PathLine { x: root.width - root.topRightRadius; y: 0 }

        // ── Top-right corner ────────────────────────────────────────────────
        PathArc {
            x: root.width; y: root.topRightRadius
            radiusX: root.topRightRadius
            radiusY: root.topRightRadius
            direction: root.invertTopRight
                ? PathArc.Counterclockwise
                : PathArc.Clockwise
        }

        // ── Right edge ───────────────────────────────────────────────────────
        PathLine { x: root.width; y: root.height - root.bottomRightRadius }

        // ── Bottom-right corner ──────────────────────────────────────────────
        PathArc {
            x: root.width - root.bottomRightRadius; y: root.height
            radiusX: root.bottomRightRadius
            radiusY: root.bottomRightRadius
            direction: root.invertBottomRight
                ? PathArc.Counterclockwise
                : PathArc.Clockwise
        }

        // ── Bottom edge ──────────────────────────────────────────────────────
        PathLine { x: root.bottomLeftRadius; y: root.height }

        // ── Bottom-left corner ───────────────────────────────────────────────
        PathArc {
            x: 0; y: root.height - root.bottomLeftRadius
            radiusX: root.bottomLeftRadius
            radiusY: root.bottomLeftRadius
            direction: root.invertBottomLeft
                ? PathArc.Counterclockwise
                : PathArc.Clockwise
        }

        // ── Left edge ────────────────────────────────────────────────────────
        PathLine { x: 0; y: root.topLeftRadius }

        // ── Top-left corner (closes back to startX/startY) ───────────────────
        PathArc {
            x: root.topLeftRadius; y: 0
            radiusX: root.topLeftRadius
            radiusY: root.topLeftRadius
            direction: root.invertTopLeft
                ? PathArc.Counterclockwise
                : PathArc.Clockwise
        }
    }
}
