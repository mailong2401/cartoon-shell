import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris


Rectangle {
    id: musicPlayer
    color: theme.primary.background
    border.color: theme.button.border
    border.width: 3
    radius: currentSizes.radius?.normal || 10

    property string currentSong: musicPlayer.mprisPlayer ? (musicPlayer.mprisPlayer.trackTitle || "No song playing") : "No song playing"
    property string currentArtist: musicPlayer.mprisPlayer ? (musicPlayer.mprisPlayer.trackArtist || "Unknown Artist") : "Unknown Artist"
    property var mprisPlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    property bool isPlaying: musicPlayer.mprisPlayer.isPlaying
    property var theme: currentTheme



    RowLayout {
        anchors.fill: parent
        anchors.margins: currentSizes.spacing?.normal || 8
        spacing: currentSizes.spacing?.medium || 12

        // Song info with marquee effect
        ColumnLayout {
            id: songInfoColumn
            Layout.fillWidth: true
            spacing: currentSizes.spacing?.small || 2

            // Container for song title with marquee effect (like MusicPanel)
            Item {
                id: songContainer
                Layout.fillWidth: true
                Layout.preferredHeight: currentSizes.musicPlayerLayout?.songContainerHeight || 20
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
                    font.pixelSize: currentSizes.fontSize?.medium || 16

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
                font.pixelSize: currentSizes.fontSize?.small || 10
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Controls
        RowLayout {
            id: controlsRow
            spacing: currentSizes.spacing?.medium || 12
            Layout.fillHeight: true
            Layout.preferredWidth: childrenRect.width
            Layout.minimumWidth: childrenRect.width
            Layout.maximumWidth: childrenRect.width

            // Previous button
            Image {
                id: preBtn
                source: theme.type === "dark" ? "../../assets/music/pre_dark.png" : "../../assets/music/pre.png"
                Layout.preferredWidth: currentSizes.iconSize?.normal || 30
                Layout.preferredHeight: currentSizes.iconSize?.normal || 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: musicPlayer.mprisPlayer?.next()
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
                Layout.preferredWidth: currentSizes.iconSize?.normal || 30
                Layout.preferredHeight: currentSizes.iconSize?.normal || 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: musicPlayer.mprisPlayer?.togglePlaying()
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }

                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Next button
            Image {
                id: nextBtn
                source: theme.type === "dark" ? "../../assets/music/next_dark.png" : "../../assets/music/next.png"
                Layout.preferredWidth: currentSizes.iconSize?.normal || 30
                Layout.preferredHeight: currentSizes.iconSize?.normal || 30
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: musicPlayer.mprisPlayer?.next()
                    onEntered: parent.scale = 1.2
                    onExited: parent.scale = 1.0
                }

                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }

    // Loader for MusicPanel
    Loader {
        id: musicPanelLoader
        active: panelManager.music
        source: "MusicPanel.qml"
        onLoaded: {
            item.visible = panelManager.music
        }
    }
}
