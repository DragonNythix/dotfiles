import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

Item {
    id: srcContainer
    required property var panelWindow

    implicitWidth:  srcRow.implicitWidth
    implicitHeight: srcRow.implicitHeight

    HoverHandler { id: srcHover }

	VolumePopup {
	    audioNode:    Pipewire.defaultAudioSource
	    maxVolume:    1.0
	    shown:      srcHover.hovered
	    parentWindow: panelWindow
	    xPos: {
	        let _deps = srcContainer.x + (srcContainer.parent ? srcContainer.parent.x : 0)
	        return panelWindow && panelWindow.contentItem
	            ? srcContainer.mapToItem(panelWindow.contentItem, 0, 0).x : 0
	    }
	    yPos: {
	        let _deps = srcContainer.y + srcContainer.height + (srcContainer.parent ? srcContainer.parent.y : 0)
	        return panelWindow && panelWindow.contentItem
	            ? srcContainer.mapToItem(panelWindow.contentItem, 0, 0).y + srcContainer.height : 0
	    }
	    popupWidth: srcContainer.implicitWidth
	}

    RowLayout {
        id: srcRow
        spacing: 5
        visible: Pipewire.defaultAudioSource !== null

        // Mic icon
        Text {
            text: {
                let node = Pipewire.defaultAudioSource
                if (!node || !node.ready || !node.audio) return "󰍬"
                return node.audio.muted ? "󰍭" : "󰍬"
            }
            color: {
                let node = Pipewire.defaultAudioSource
                return (node && node.ready && node.audio && node.audio.muted) ? "#6b6b8a" : "#d7d7ff"
            }
            font.pixelSize: 15
            font.family: "monospace"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    let node = Pipewire.defaultAudioSource
                    if (node && node.ready && node.audio) node.audio.muted = !node.audio.muted
                }
                onWheel: wheel => {
                    let node = Pipewire.defaultAudioSource
                    if (!node || !node.ready || !node.audio) return
                    let delta = wheel.angleDelta.y > 0 ? 0.02 : -0.02
                    node.audio.volume = Math.max(0, Math.min(1.0, node.audio.volume + delta))
                }
            }
        }

        // Mic percentage
        Text {
            id: sourceText
            text: {
                let node = Pipewire.defaultAudioSource
                if (!node || !node.ready || !node.audio || isNaN(node.audio.volume) || node.audio.muted) return "  --"
                return Math.round(node.audio.volume * 100) + "%"
            }
            color: {
                let node = Pipewire.defaultAudioSource
                return (node && node.ready && node.audio && node.audio.muted) ? "#6b6b8a" : "#d7d7ff"
            }
            font.pixelSize: 12
            font.family: "monospace"

            MouseArea {
                anchors.fill: parent
                onWheel: wheel => {
                    let node = Pipewire.defaultAudioSource
                    if (!node || !node.ready || !node.audio) return
                    let delta = wheel.angleDelta.y > 0 ? 0.02 : -0.02
                    node.audio.volume = Math.max(0, Math.min(1.0, node.audio.volume + delta))
                }
            }
        }
    }
}
