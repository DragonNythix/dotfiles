import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
// ─── Microphone (Input) ───────────────────────────────────────────────────
                        Item {
                            id: srcContainer
                            implicitWidth: srcRow.implicitWidth
                            implicitHeight: srcRow.implicitHeight

                            HoverHandler { id: srcHover }

                            // ─── Mic slider popup window ──────────────────────────────────────────────────
                            PopupWindow {
                                id: srcPopup
                                visible: srcHover.hovered
                                anchor {
                                    window: srcContainer.QsWindow.window
                                    rect: Qt.rect(
                                        sourceText.mapToItem(srcContainer.QsWindow.window.contentItem, 0, 0).x - 7,
                                        sourceText.mapToItem(srcContainer.QsWindow.window.contentItem, 0, 0).y + sourceText.height + 7,
                                        sourceText.width,
                                        0
                                    )
                                    edges: Edges.Top | Edges.Left
                                }
                                implicitWidth: srcContainer.width
                                implicitHeight: 100
                                color: "transparent"

                                    Canvas {
                                        anchors.fill: parent
                                        onPaint: {
                                            var ctx = getContext("2d")
                                            ctx.clearRect(0, 0, width, height)
                                            var r = 6
                                            var b = 1 // border width

                                            // Fill
                                            ctx.beginPath()
                                            ctx.moveTo(0, 0)                          // top-left square
                                            ctx.lineTo(width, 0)                      // top-right square
                                            ctx.lineTo(width, height - r)
                                            ctx.arcTo(width, height, width - r, height, r) // bottom-right rounded
                                            ctx.lineTo(r, height)
                                            ctx.arcTo(0, height, 0, height - r, r)   // bottom-left rounded
                                            ctx.closePath()
                                            ctx.fillStyle = "#010101"
                                            ctx.fill()

                                            // Border — left, bottom, right only (no top)
                                            ctx.beginPath()
                                            ctx.moveTo(b / 2, 0)
                                            ctx.lineTo(b / 2, height - r)
                                            ctx.arcTo(b / 2, height - b / 2, r, height - b / 2, r)
                                            ctx.lineTo(width - r, height - b / 2)
                                            ctx.arcTo(width - b / 2, height - b / 2, width - b / 2, height - r, r)
                                            ctx.lineTo(width - b / 2, 0)
                                            ctx.strokeStyle = "#5B4CA2"
                                            ctx.lineWidth = b
                                            ctx.stroke()
                                        }
                                    }

                                    Slider {
                                        anchors.centerIn: parent
                                        orientation: Qt.Vertical
                                        implicitHeight: parent.height - 10
                                        from: 0
                                        to: 1.0
                                        value: {
                                            let node = Pipewire.defaultAudioSource
                                            if (!node || !node.ready || !node.audio || isNaN(node.audio.volume)) return 0
                                            return node.audio.volume
                                        }
                                        onMoved: {
                                            let node = Pipewire.defaultAudioSource
                                            if (!node || !node.ready || !node.audio) return
                                            node.audio.volume = value
                                        }
                                    }
                                }
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

                                // Mic percentage label
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