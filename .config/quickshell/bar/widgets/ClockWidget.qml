import QtQuick

Text {
    id: clock
    property var now: new Date()
    text: Qt.formatDateTime(now, "ddd, MMM d   hh:mm")
    color: "#d7d7ff"
    font.pixelSize: 13
    font.family: "monospace"

    Timer {
        interval: 1000
        running:  true
        repeat:   true
        onTriggered: clock.now = new Date()
    }
}
