import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
                       // ─── Speaker (Output) ────────────────────────────────────────────────────
                        Item {
                                PwObjectTracker {
                                    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
                                }
                            id: sinkContainer
                            implicitWidth: sinkRow.implicitWidth
                            implicitHeight: sinkRow.implicitHeight

                            HoverHandler { id: sinkHover }

                            // ─── Speaker slider popup window ─────────────────────────────────────────────
                            PopupWindow {
                                id: sinkPopup
                                visible: sinkHover.hovered
                                anchor {
                                    window: sinkContainer.QsWindow.window
                                    rect: Qt.rect(
                                        sinkText.mapToItem(sinkContainer.QsWindow.window.contentItem, 0, 0).x - 7,
                                        sinkText.mapToItem(sinkContainer.QsWindow.window.contentItem, 0, 0).y + sinkText.height + 7,
                                        sinkText.width,
                                        0
                                    )
                                    edges: Edges.Top | Edges.Left
                                }
                                implicitWidth: sinkContainer.width
                                implicitHeight: 100
                                color: "transparent"

                                Rectangle {
                                    anchors.fill: parent
                                    radius: 6
                                    color: "#010101"
                                    border.color: "#5B4CA2"

                                    Slider {
                                        anchors.centerIn: parent
                                        orientation: Qt.Vertical
                                        implicitHeight: parent.height - 10
                                        from: 0
                                        to: 1.5
                                        value: {
                                            let node = Pipewire.defaultAudioSink
                                            if (!node || !node.ready || !node.audio || isNaN(node.audio.volume)) return 0
                                            return node.audio.volume
                                        }
                                        onMoved: {
                                            let node = Pipewire.defaultAudioSink
                                            if (!node || !node.ready || !node.audio) return
                                            node.audio.volume = value
                                        }
                                    }
                                }
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

                                // Speaker percentage label
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