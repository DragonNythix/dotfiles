import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Item {
    required property var  hyprMonitor
    required property real borderThickness

    // Pill geometry scales +2px on each axis across the full 0→10 border range,
    // animating in sync with the border so the transition feels continuous.
    readonly property real pillWidth:  26 
    readonly property real pillHeight: 23
    readonly property real pillFont:   11

    implicitWidth:  wsContainer.width
    implicitHeight: wsContainer.height

    Item {
        id: wsContainer
        anchors.centerIn: parent
        width:  wsRow.width
        height: wsRow.height

        property real activeX: 0
        property real activeY: 0

        // Sliding highlight that lives behind all pills
        Rectangle {
            id: slideHighlight
            width:  pillWidth
            height: pillHeight
            radius: 6
            color:  "#5B4CA2"
            x:      wsContainer.activeX
            y:      wsContainer.activeY

            property bool initialized: false

            Behavior on x {
                enabled: slideHighlight.initialized
                NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
            }
        }

        RowLayout {
            id: wsRow
            anchors.centerIn: parent
            spacing: 5

            Repeater {
                model: Hyprland.workspaces
                delegate: Rectangle {
                    id: pill

                    visible: {
                        if (!hyprMonitor || !modelData || !modelData.monitor)
                            return false
                        let isCorrectMonitor = (modelData.monitor === hyprMonitor)
                        if (modelData.name.includes("gayming") && isCorrectMonitor)
                            return true
                        let isSpecial = modelData.id < 0 || modelData.name.includes("special")
                        return isCorrectMonitor && !isSpecial
                    }

                    width:  visible ? pillWidth  : 0
                    height: visible ? pillHeight : 0
                    Layout.preferredWidth: width
                    clip:   true
                    radius: 6

                    property bool isActive:    modelData ? modelData.active : false
                    property int  windowCount: modelData ? modelData.toplevels.values.length : 0
                    property bool hasWindows:  windowCount > 0

                    // Transparent when active — the highlight shows through from behind
                    color:        isActive ? "transparent" : (hasWindows ? "#313244" : "#151515")
                    border.width: !isActive && hasWindows ? 1 : 0
                    border.color: "#5B4CA2"

                    Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation   { duration: 120 } }

                    // Report position to the container so the highlight can follow
                    function reportPosition() {
                        if (!isActive || !visible) return
                        let mapped        = mapToItem(wsContainer, 0, 0)
                        wsContainer.activeX          = mapped.x
                        wsContainer.activeY          = mapped.y
                        slideHighlight.initialized   = true
                    }

                    onIsActiveChanged:     Qt.callLater(reportPosition)
                    onVisibleChanged:      Qt.callLater(reportPosition)
                    onXChanged:            Qt.callLater(reportPosition)
                    Component.onCompleted: Qt.callLater(reportPosition)

                    Text {
                        anchors.centerIn: parent
                        text: {
                            if (!modelData) return ""
                            let n = parseInt(modelData.name)
                            if (isNaN(n)) return modelData.name.charAt(0)
                            return (((n - 1) % 10) + 1).toString()
                        }
                        color:          "#d7d7ff"
                        font.pixelSize: pillFont
                        font.bold:      parent.isActive
                        opacity:        parent.visible ? 1 : 0
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape:  Qt.PointingHandCursor
                        onClicked:	  modelData.activate()
                    }
                }
            }
        }
    }
}
