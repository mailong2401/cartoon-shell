import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Io



Rectangle {
    id: root
    property var theme: currentTheme
    property var mprisPlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    property string currentSong: "No song playing"
    property string currentArtist: "Unknown Artist"
    property string albumArt: ""
    property int position: 0
    property int duration: 0
    property var sizes: currentSizes?.musicCard || {}

    Layout.fillWidth: true
    Layout.preferredHeight: 220
    Layout.preferredWidth: 350
    radius: sizes.radius || 28
    color: theme.primary.background
    border.width: sizes.borderWidth || 3
    border.color: theme.normal.black


    RowLayout {
        anchors.fill: parent
        anchors.margins: sizes.margins || 20
        spacing: sizes.spacing || 25

        // Album Art (Circular with rotation) - Left Side
        Item {
                    Layout.preferredWidth: sizes.albumArtSize || 160
                    Layout.preferredHeight: sizes.albumArtSize || 160

                    // Rotating container
                    Item {
                        id: rotatingContainer
                        anchors.fill: parent

                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 10000
                            loops: Animation.Infinite
                            running: root.mprisPlayer.isPlaying
                        }

                        ClippingRectangle {
                            id: albumArtContainer
                            anchors.fill: parent
                            radius: width / 2
                            color: theme.primary.dim_background
                            border.color: theme.normal.black
                            border.width: sizes.borderWidth || 3

                            Image {
                                id: albumImage
                                anchors.fill: parent
                                source: root.mprisPlayer ? (root.mprisPlayer.trackArtUrl ?? "") : ""
                                fillMode: Image.PreserveAspectCrop
                                visible: status === Image.Ready
                                cache: false
                                asynchronous: true
                                smooth: true
                            }

                            // Placeholder when no album art
                            Text {
                                anchors.centerIn: parent
                                text: "No Art"
                                font.family: "ComicShannsMono Nerd Font"
                                font.pixelSize: sizes.placeholderFontSize || 14
                                color: theme.primary.dim_foreground
                                visible: albumImage.status !== Image.Ready
                            }
                        }
                    }
                }

        // Track Info & Controls - Right Side
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: sizes.infoSpacing || 8

            // Song title with marquee
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: songText.height
                clip: true

                Text {
                    id: songText
                    text: root.mprisPlayer ? (root.mprisPlayer.trackTitle || "No song playing") : "No song playing"
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: sizes.songFontSize || 20
                    font.bold: true
                    color: theme.primary.foreground

                    property bool needsMarquee: width > parent.width
                    x: 0

                    SequentialAnimation on x {
                        running: songText.needsMarquee && root.visible
                        loops: Animation.Infinite

                        PauseAnimation { duration: 2000 }
                        NumberAnimation {
                            to: -(songText.width - songText.parent.width)
                            duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
                            easing.type: Easing.Linear
                        }
                        PauseAnimation { duration: 2000 }
                        NumberAnimation {
                            to: 0
                            duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
                            easing.type: Easing.Linear
                        }
                    }
                }
            }

            // Artist name
            Text {
                Layout.fillWidth: true
                text: root.mprisPlayer ? (root.mprisPlayer.trackArtist || "Unknown Artist") : "Unknown Artist"
                font.family: "ComicShannsMono Nerd Font"
                font.pixelSize: sizes.artistFontSize || 14
                color: theme.primary.dim_foreground
                elide: Text.ElideRight
            }

            Item { Layout.fillHeight: true }

            // Controls Row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.controlsHeight || 48
                spacing: sizes.controlsSpacing || 12

                Item { Layout.fillWidth: true }

                // Previous button
                Rectangle {
                    Layout.preferredWidth: sizes.controlButtonSize || 32
                    Layout.preferredHeight: sizes.controlButtonSize || 32
                    radius: sizes.controlButtonRadius || 16
                    color: prevArea.containsMouse ? theme.button.background_select : theme.button.background

                    Image {
                        anchors.centerIn: parent
                        source: theme.type === "dark" ? "../../../assets/music/pre_dark.png" : "../../../assets/music/pre.png"
                        width: sizes.controlIconSize || 28
                        height: sizes.controlIconSize || 28
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: prevArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.mprisPlayer?.previous()
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // Play/Pause button
                Rectangle {
                    Layout.preferredWidth: sizes.playButtonSize || 40
                    Layout.preferredHeight: sizes.playButtonSize || 40
                    radius: sizes.playButtonRadius || 20
                    color: playArea.containsMouse ? theme.normal.blue : theme.button.background
                    Image {
                        anchors.centerIn: parent
                        source: {
    if (!root.mprisPlayer) {
        return theme.type === "dark" ? "../../../assets/music/play_dark.png" : "../../../assets/music/play.png"
    }
    var suffix = theme.type === "dark" ? "_dark" : ""
    return root.mprisPlayer.isPlaying ? "../../../assets/music/pause" + suffix + ".png" : "../../../assets/music/play" + suffix + ".png"
}
                        width: sizes.playIconSize || 32
                        height: sizes.playIconSize || 32
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: playArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.mprisPlayer?.togglePlaying()
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                // Next button
                Rectangle {
                    Layout.preferredWidth: sizes.controlButtonSize || 32
                    Layout.preferredHeight: sizes.controlButtonSize || 32
                    radius: sizes.controlButtonRadius || 16
                    color: nextArea.containsMouse ? theme.button.background_select : theme.button.background
                    Image {
                        anchors.centerIn: parent
                        source: theme.type === "dark" ? "../../../assets/music/next_dark.png" : "../../../assets/music/next.png"
                        width: sizes.controlIconSize || 28
                        height: sizes.controlIconSize || 28
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: nextArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.mprisPlayer?.next()
                    }

                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                Item { Layout.fillWidth: true }
            }

            // Progress bar with time
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                visible: root.mprisPlayer && root.mprisPlayer.length > 0

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: formatTime(root.mprisPlayer ? root.mprisPlayer.position : 0)
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: sizes.timeFontSize || 11
                        color: theme.primary.dim_foreground
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: formatTime(root.mprisPlayer ? root.mprisPlayer.length : 0)
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: sizes.timeFontSize || 11
                        color: theme.primary.dim_foreground
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: sizes.progressBarHeight || 6
                    radius: sizes.progressBarRadius || 3
                    color: theme.primary.dim_background

                    Rectangle {
                        id: progressFill
                        height: parent.height
                        width: root.mprisPlayer ? Math.min(parent.width, parent.width * (root.mprisPlayer.position / Math.max(1, root.mprisPlayer.length))) : 0
                        radius: parent.radius
                        color: theme.normal.blue

                        Behavior on width {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: 5 }
        }
    }
}
