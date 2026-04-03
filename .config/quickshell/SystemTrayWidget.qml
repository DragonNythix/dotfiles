import Quickshell.Services.SystemTray
import QtQuick

Row {
    required property var panelWindow
    spacing: 4

    Repeater {
        model: SystemTray.items
        delegate: Item {
            width: 20; height: 20


			Image {
			    anchors.fill: parent
			    source: modelData.icon
			    sourceSize: Qt.size(20, 20)
			}
			MouseArea {
			    anchors.fill: parent
			    acceptedButtons: Qt.LeftButton | Qt.RightButton
			    onClicked: mouse => {
			        if (mouse.button === Qt.RightButton) {
			            var pos = mapToItem(null, mouse.x, mouse.y)
			            modelData.display(panelWindow, pos.x, pos.y)
			        } else {
			            modelData.activate()
			        }
			    }
			}


        }
    }
}

