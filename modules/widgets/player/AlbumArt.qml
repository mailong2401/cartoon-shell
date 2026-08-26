// AlbumArt.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.services
import qs.components

Item {
    id: root
    width: ScalerService.s(100)
    height: ScalerService.s(100)
    property real animationProgress: 0

    // Rotating container
    Item {
        id: rotatingContainer
        anchors.fill: parent

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 10000
            loops: Animation.Infinite
            running: Players.mprisPlayer?.isPlaying ?? false
        }

        ClippingRectangle {
            id: rootContainer
            anchors.fill: parent
            radius: ScalerService.s(50)
            color: theme.primary.dim_background
            border.color: theme.normal.black
            border.width: ScalerService.s(3)
            opacity: root.animationProgress > 0.3 ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            Image {
                id: albumImage
                anchors.fill: parent
                source: Players.getArtUrl(Players.mprisPlayer)
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
                cache: false
                asynchronous: true
                smooth: true
            }

            // Placeholder when no album art
            CustomText {
                name: "No Art"
                size: "xs"
                anchors.centerIn: parent
                visible: albumImage.status !== Image.Ready
            }
        }
    }
}
