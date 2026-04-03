import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

// Shared audio control widget used by SinkWidget and SourceWidget.
// Callers provide audioNode, maxVolume, and iconText (as a binding).
Item {
    id: root

    required property var  panelWindow
    required property var  audioNode
    required property real maxVolume
    property  string       iconText: "?"   // override with a binding in the caller

    implicitWidth:  row.implicitWidth
    implicitHeight: row.implicitHeight

    // Shared volume-adjustment helper — avoids duplicating the clamp logic
    function adjustVolume(delta) {
        let n = audioNode
        if (!n?.ready || !n.audio) return
        n.audio.volume = Math.max(0, Math.min(maxVolume, n.audio.volume + delta))
    }

    HoverHandler { id: hover }

    VolumePopup {
        audioNode:    root.audioNode
        maxVolume:    root.maxVolume
        shown:        hover.hovered
        parentWindow: root.panelWindow

        // void() reads the properties so QML tracks them as binding dependencies,
        // which forces re-evaluation when the widget moves.
        xPos: {
            void(root.x, root.parent?.x)
            return root.panelWindow?.contentItem
                ? root.mapToItem(root.panelWindow.contentItem, 0, 0).x : 0
        }
        yPos: {
            void(root.y, root.height, root.parent?.y)
            return root.panelWindow?.contentItem
                ? root.mapToItem(root.panelWindow.contentItem, 0, 0).y + root.height : 0
        }
        popupWidth: root.implicitWidth
    }

    RowLayout {
        id: row
        spacing: 5
        visible: root.audioNode !== null

        // Icon (mute toggle + scroll)
        Text {
            text:           root.iconText
            color:          (root.audioNode?.audio?.muted ?? false) ? "#6b6b8a" : "#d7d7ff"
            font.pixelSize: 15
            font.family:    "monospace"

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                onClicked: {
                    let n = root.audioNode
                    if (n?.ready && n.audio) n.audio.muted = !n.audio.muted
                }
                onWheel: wheel => root.adjustVolume(wheel.angleDelta.y > 0 ? 0.02 : -0.02)
            }
        }

        // Percentage label (scroll only)
        Text {
            readonly property bool muted: root.audioNode?.audio?.muted ?? false

            text: (!root.audioNode?.ready || !root.audioNode.audio
                   || isNaN(root.audioNode.audio.volume) || muted)
                  ? "  --"
                  : Math.round(root.audioNode.audio.volume * 100) + "%"

            color:          muted ? "#6b6b8a" : "#d7d7ff"
            font.pixelSize: 12
            font.family:    "monospace"

            MouseArea {
                anchors.fill: parent
                onWheel: wheel => root.adjustVolume(wheel.angleDelta.y > 0 ? 0.02 : -0.02)
            }
        }
    }
}
