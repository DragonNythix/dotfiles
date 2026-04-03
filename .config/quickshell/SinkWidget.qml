import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

Item {
    id: sinkContainer
    required property var panelWindow

    implicitWidth:  sinkRow.implicitWidth
    implicitHeight: sinkRow.implicitHeight

    HoverHandler { id: sinkHover }

	VolumePopup {
	    audioNode:    Pipewire.defaultAudioSink
	    maxVolume:    1.5
	    shown:      sinkHover.hovered
	    parentWindow: panelWindow
	    xPos: {
	        let _deps = sinkContainer.x + (sinkContainer.parent ? sinkContainer.parent.x : 0)
	        return panelWindow && panelWindow.contentItem
	            ? sinkContainer.mapToItem(panelWindow.contentItem, 0, 0).x : 0
	    }
	    yPos: {
	        let _deps = sinkContainer.y + sinkContainer.height + (sinkContainer.parent ? sinkContainer.parent.y : 0)
	        return panelWindow && panelWindow.contentItem
	            ? sinkContainer.mapToItem(panelWindow.contentItem, 0, 0).y + sinkContainer.height : 0
	    }
	    popupWidth: sinkContainer.implicitWidth
	}

    RowLayout {
        id: sinkRow
        spacing: 5
        visible: Pipewire.defaultAudioSink !== null

        // Speaker icon
        Text {
            text: {
                let node = Pipewire.defaultAudioSink
                if (!node || !node.ready || !node.audio || isNaN(node.audio.volume)) return "󰕾"
                if (node.audio.muted) return "󰖁"
                let v = Math.round(node.audio.volume * 100)
                if (v === 0) return "󰕿"
                if (v < 50) return "󰖀"
                return "󰕾"
            }
            color: {
                let node = Pipewire.defaultAudioSink
                return (node && node.ready && node.audio && node.audio.muted) ? "#6b6b8a" : "#d7d7ff"
            }
            font.pixelSize: 15
            font.family: "monospace"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    let node = Pipewire.defaultAudioSink
                    if (node && node.ready && node.audio) node.audio.muted = !node.audio.muted
                }
                onWheel: wheel => {
                    let node = Pipewire.defaultAudioSink
                    if (!node || !node.ready || !node.audio) return
                    let delta = wheel.angleDelta.y > 0 ? 0.02 : -0.02
                    node.audio.volume = Math.max(0, Math.min(1.5, node.audio.volume + delta))
                }
            }
        }

        // Volume percentage
        Text {
            id: sinkText
            text: {
                let node = Pipewire.defaultAudioSink
                if (!node || !node.ready || !node.audio || isNaN(node.audio.volume) || node.audio.muted) return "  --"
                return Math.round(node.audio.volume * 100) + "%"
            }
            color: {
                let node = Pipewire.defaultAudioSink
                return (node && node.ready && node.audio && node.audio.muted) ? "#6b6b8a" : "#d7d7ff"
            }
            font.pixelSize: 12
            font.family: "monospace"

            MouseArea {
                anchors.fill: parent
                onWheel: wheel => {
                    let node = Pipewire.defaultAudioSink
                    if (!node || !node.ready || !node.audio) return
                    let delta = wheel.angleDelta.y > 0 ? 0.02 : -0.02
                    node.audio.volume = Math.max(0, Math.min(1.5, node.audio.volume + delta))
                }
            }
        }
    }
}
