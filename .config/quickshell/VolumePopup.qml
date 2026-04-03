import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls

PopupWindow {
    id: popup

    required property var  audioNode
    required property real maxVolume
    required property var  parentWindow
    required property real xPos
    required property real yPos
    required property real popupWidth
    required property bool shown

    anchor {
        window: parentWindow
        rect:   Qt.rect(xPos, yPos, popupWidth, 0)
        edges:  Edges.Top | Edges.Left
    }

    implicitWidth:  Math.max(popupWidth, 44)
    implicitHeight: 110
    color: "transparent"

    // Keep the Wayland surface alive only while visible, destroyed after fade-out
    visible: content.opacity > 0

    onShownChanged: shown ? showAnim.start() : hideAnim.start()

    // ── Animations ───────────────────────────────────────────────────────────

    NumberAnimation {
        id: showAnim
        target: content; property: "opacity"
        from: 0; to: 1
        duration: 160; easing.type: Easing.OutCubic
        onStarted: { slideOffset.y = 8; slideAnim.to = 0; slideAnim.start() }
    }

    NumberAnimation {
        id: hideAnim
        target: content; property: "opacity"
        from: 1; to: 0
        duration: 120; easing.type: Easing.InCubic
        onStarted: { slideAnim.to = 8; slideAnim.start() }
    }

    NumberAnimation {
        id: slideAnim
        target: slideOffset; property: "y"
        duration: 160; easing.type: Easing.OutCubic
    }

    Translate { id: slideOffset; y: 8 }

    // ── Content ──────────────────────────────────────────────────────────────

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        transform: slideOffset

        // Background shape — inverted top corners create a concave notch that
        // visually "connects" the popup to the bar widget above it.
        // topLeftRadius / topRightRadius should match the bar's border radius (12).
        RoundedShape {
		    anchors.fill: parent
		    fillColor:   "#010101"
		    strokeColor: "#5B4CA2"
		    strokeWidth: 2

		    topLeftRadius:     0   // square — flush against the bar
		    topRightRadius:    0
		    bottomLeftRadius:  8
		    bottomRightRadius: 8
        }

        Slider {
            anchors.centerIn: parent
            orientation: Qt.Vertical
            implicitHeight: parent.height - 20
            from:  0
            to:    maxVolume
            value: {
                if (!audioNode || !audioNode.ready || !audioNode.audio
                        || isNaN(audioNode.audio.volume)) return 0
                return audioNode.audio.volume
            }
            onMoved: {
                if (!audioNode || !audioNode.ready || !audioNode.audio) return
                audioNode.audio.volume = value
            }
        }
    }
}
