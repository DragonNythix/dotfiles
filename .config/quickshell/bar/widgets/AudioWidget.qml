import QtQuick
import QtQuick.Layouts

// Purely visual widget. Callers (SinkWidget, SourceWidget) read from Pipewire
// directly and pass in plain values — this avoids losing Pipewire's reactivity
// by routing the node object through a QML property.
Item {
    id: root

    // ── Inputs from caller ────────────────────────────────────────────────────
    required property string iconText    // icon glyph
    required property real   volume      // 0.0 – maxVolume
    required property real   maxVolume
    required property bool   isMuted
    required property bool   isAvailable // false → hide everything
    required property var    popup       // the PopupWindow component (caller owns it)

    implicitWidth:  row.implicitWidth
    implicitHeight: row.implicitHeight

    // ── Derived visuals ───────────────────────────────────────────────────────
    readonly property int volPct: Math.round(volume * 100)

    readonly property color accentColor: {
        if (!isAvailable || isMuted) return "#46465f"
        if (volPct >= 90) return "#ff5f9e"
        if (volPct >= 60) return "#b060ef"
        if (volPct >= 30) return "#8a7fff"
        return "#6ab0f5"
    }

    HoverHandler { id: hover }
    readonly property bool hovered: hover.hovered

    RowLayout {
        id: row
        spacing: 5
        visible: root.isAvailable

        // Icon
        Text {
            text:           root.iconText
            font.pixelSize: 15
            font.family:    "monospace"
            color:          root.accentColor
            Behavior on color { ColorAnimation { duration: 180 } }
        }

        // ── Mini equalizer bars ───────────────────────────────────────────────
        Row {
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Repeater {
                model: 5

                Item {
                    width:  3
                    height: 14
                    Layout.alignment: Qt.AlignVCenter

                    readonly property int  maxBarH: [4, 6, 9, 7, 5][index]
                    readonly property bool lit: !root.isMuted
                                                && (root.volume * (4.5 / root.maxVolume)) >= index

                    Rectangle {
                        width:  3
                        radius: 1.5
                        anchors.bottom: parent.bottom
                        color:  parent.lit ? root.accentColor : "#252535"

                        Behavior on color  { ColorAnimation { duration: 140 } }
                        Behavior on height { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                        height: {
                            if (root.isMuted) return 2
                            if (!parent.lit)  return parent.maxBarH * 0.35
                            return parent.maxBarH * (0.55 + Math.min(1, root.volume / root.maxVolume) * 0.45)
                        }
                    }

                    SequentialAnimation on opacity {
                        running: root.isAvailable && !root.isMuted
                        loops:   Animation.Infinite
                        PauseAnimation  { duration: index * 120 }
                        NumberAnimation { to: 0.65; duration: 500; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0;  duration: 500; easing.type: Easing.InOutSine }
                    }
                    opacity: (!root.isAvailable || root.isMuted) ? 0.4 : 1.0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }
        }

        // Percentage label
        Text {
            text:           root.isMuted ? "  --" : root.volPct + "%"
            color:          root.accentColor
            font.pixelSize: 12
            font.family:    "monospace"
            Behavior on color { ColorAnimation { duration: 180 } }
        }
    }
}
