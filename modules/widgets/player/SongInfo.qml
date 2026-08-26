// SongInfo.qml
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

ColumnLayout {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: ScalerService.s(8)
    property real animationProgress: 0

    Item {
        Layout.fillHeight: true
    }

    // Song title with marquee effect
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: songText.height
        clip: true

        CustomText {
            id: songText
            name: Players.mprisPlayer?.trackTitle ?? "Not Playing"
            isBold: true
            size: "small"
            opacity: root.animationProgress > 0.4 ? 1 : 0

            property bool needsMarquee: width > parent.width

            x: 0

            SequentialAnimation on x {
                id: marqueeAnimation
                running: songText.needsMarquee
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 2000
                }
                NumberAnimation {
                    to: -(songText.width - songText.parent.width)
                    duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
                    easing.type: Easing.Linear
                }
                PauseAnimation {
                    duration: 2000
                }
                NumberAnimation {
                    to: 0
                    duration: Math.max(2000, (songText.width - songText.parent.width) * 20)
                    easing.type: Easing.Linear
                }
            }
        }
    }

    CustomText {
        name: Players.mprisPlayer ? (Players.mprisPlayer.trackArtist || "Unknown Artist") : "Unknown Artist"
        size: "xs"
        textColor: theme.primary.dim_foreground
        elide: Text.ElideRight
        Layout.fillWidth: true
        opacity: root.animationProgress > 0.5 ? 1 : 0
    }

    Item {
        Layout.fillHeight: true
    }
}
