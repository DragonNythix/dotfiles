pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    
    required property real        borderThickness
    required property real        barHeight

    property int   borderRounding: 14
    property color borderColor:    "#040316"

    WlrLayershell.layer: WlrLayer.Bottom
    exclusiveZone:       -1
    mask:                Region {}

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"

    Rectangle {
        anchors {
            fill:      parent
            topMargin: root.barHeight   // don't draw over the bar
        }
        color: root.borderColor

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource:       cutoutMask
            maskEnabled:      true
            maskInverted:     true
            maskThresholdMin: 0.5
            maskSpreadAtMin:  1.0
        }
    }

    Item {
        id: cutoutMask
        anchors {
            fill:      parent
            topMargin: root.barHeight   // mask must match the rectangle's geometry
        }
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
