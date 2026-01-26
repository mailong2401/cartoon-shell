import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris


Rectangle {
    id: root
    color: theme.primary.background
    border.color: theme.button.border
    border.width: 3
    radius: 10

    property string currentSong: root.player ? (root.player.trackTitle || "No song playing") : "No song playing"
    property string currentArtist: root.player ? (root.player.trackArtist || "Unknown Artist") : "Unknown Artist"
    property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    property bool isPlaying: player ? player.isPlaying : false
    property var theme: currentTheme



    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 12

        // Song info with marquee effect
        ColumnLayout {
            id: songInfoColumn
            Layout.fillWidth: true
            spacing: 2

            // Container for song title with marquee effect (like MusicPanel)
            Item {
                id: songContainer
                Layout.fillWidth: true
                Layout.preferredHeight: 25
                clip: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        panelManager.togglePanel("music")
                    }
                    onEntered: songContainer.opacity = 0.8
                    onExited: songContainer.opacity = 1.0
                }

                Text {
                    id: songText
                    text: currentSong
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 16

                    property bool needsMarquee: width > songContainer.width

                    x: 0

                    SequentialAnimation on x {
                        id: marqueeAnimation
                        running: songText.needsMarquee
                        loops: Animation.Infinite

                        // Pause at start
                        PauseAnimation { duration: 2000 }

                        // Scroll left
                        NumberAnimation {
                            to: -(songText.width - songContainer.width)
                            duration: Math.max(2000, (songText.width - songContainer.width) * 20)
                            easing.type: Easing.Linear
                        }

                        // Pause at end
                        PauseAnimation { duration: 2000 }

                        // Scroll back
                        NumberAnimation {
                            to: 0
                            duration: Math.max(2000, (songText.width - songContainer.width) * 20)
                            easing.type: Easing.Linear
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }

            // Artist name
            Text {
                text: currentArtist
                color: theme.primary.dim_foreground
                font.family: "ComicShannsMono Nerd Font"
                font.pixelSize: 10
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Controls
        RowLayout {
            id: controlsRow
            spacing: 12
            Layout.fillHeight: true
            Layout.preferredWidth: childrenRect.width
            Layout.minimumWidth: childrenRect.width
            Layout.maximumWidth: childrenRect.width

            // Previous button
            Image {
                id: preBtn
                source: theme.type === "dark" ? "../../assets/music/pre_dark.png" : "../../assets/music/pre.png"
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: root.player?.next()
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }

                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Play/Pause button
            Image {
                id: playPauseBtn
                source: {
                            var suffix = theme.type === "dark" ? "_dark" : ""
                            return isPlaying ? "../../assets/music/pause" + suffix + ".png" : "../../assets/music/play" + suffix + ".png"
                        }
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.player?.togglePlaying()
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }

                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Next button
            Image {
                id: nextBtn
                source: theme.type === "dark" ? "../../assets/music/next_dark.png" : "../../assets/music/next.png"
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.player?.next()
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }

                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }

    // Loader for MusicPanel

}
