import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls

// Popup slider shown on hover over AudioWidget.
// Callers set audioNode, maxVolume, shown, parentWindow, xPos, yPos, popupWidth.
Item {
    id: root

    required property var  audioNode
    required property real maxVolume
    required property bool shown
    required property var  parentWindow
    required property real xPos
    required property real yPos
    required property real popupWidth

    PopupWindow {
        visible: root.shown
        color: "transparent"

        anchor {
            window: root.parentWindow
            rect:   Qt.rect(root.xPos, root.yPos, root.popupWidth, 0)
            edges:  Edges.Top | Edges.Left
        }

        implicitWidth:  root.popupWidth
        implicitHeight: 100

        Rectangle {
            anchors.fill: parent
            radius:       6
            color:        "#010101"
            border.color: "#5B4CA2"
            border.width: 1

            Slider {
                anchors.centerIn: parent
                orientation:      Qt.Vertical
                implicitHeight:   parent.height - 10
                from:  0
                to:    root.maxVolume

                value: {
                    let n = root.audioNode
                    if (!n || !n.ready || !n.audio || isNaN(n.audio.volume)) return 0
                    return n.audio.volume
                }
                onMoved: {
                    let n = root.audioNode
                    if (!n || !n.ready || !n.audio) return
                    n.audio.volume = value
                }
            }
        }
    }
}
