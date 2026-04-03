import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    required property var screen          // passed in from shell.qml Variants
    readonly property var hyprMonitor: Hyprland.monitorFor(bar.screen)

    anchors { top: true; left: true; right: true }
    implicitHeight: 34
    color: "transparent"

	Rectangle {
	    anchors.fill: parent
	    radius: 12
	    color: "#010101"
	    border.color: "#5B4CA2"
	    border.width: 1

	    Item {
	        anchors.fill: parent
	        anchors.leftMargin: 14
	        anchors.rightMargin: 14

	        // Left
	        ClockWidget {
	            anchors.left: parent.left
	            anchors.verticalCenter: parent.verticalCenter
	        }

	        // Center — truly centered, unaffected by left/right sizes
	        WorkspaceBar {
	            hyprMonitor: bar.hyprMonitor
	            anchors.centerIn: parent
	        }

	        // Right
	        RowLayout {
	            anchors.right: parent.right
	            anchors.verticalCenter: parent.verticalCenter
	            spacing: 12

	            SinkWidget   { panelWindow: bar }
	            Rectangle    { width: 1; height: 16; color: "#2a2a3a" }
	            SourceWidget { panelWindow: bar }
	            Rectangle    { width: 1; height: 16; color: "#2a2a3a" }
	            SystemTrayWidget { panelWindow: bar }
	        }
	    }
	}
}
