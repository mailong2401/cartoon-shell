import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell
import qs.commons
import qs.components
import qs.services
import "." as Com

Item {
    id: root
    implicitWidth: ScalerService.s(480)
    implicitHeight: ScalerService.s(250)
    property real animationProgress: 0
    SequentialAnimation on animationProgress {
        running: true

        NumberAnimation {
            from: 0
            to: 1
            duration: 500
            easing.type: Easing.Linear
        }
    }
    Rectangle {
        anchors.centerIn: parent
        implicitWidth: root.animationProgress > 0 ? parent.width : 0
        implicitHeight: root.animationProgress > 0 ? parent.height : 0
        Behavior on implicitHeight {
            NumberAnimation {
                id: heightAnim
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
        Behavior on implicitWidth {
            NumberAnimation {
                id: widthAnim
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
        Loader {
            anchors.fill: parent

            active: !heightAnim.running && !widthAnim.running

            sourceComponent: FloatingCircles {
                circleColor: theme.button.text
                anchors.fill: parent
                circleCount: 2
                minOpacity: 0.02
                maxOpacity: 0.04
            }
        }
        color: theme.primary.background
        border.color: theme.button.border
        radius: ScalerService.s(Settings.appearance.radius1)
        border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(20)
            spacing: ScalerService.s(20)
            // Album art and info section
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: ScalerService.s(180)
                spacing: ScalerService.s(20)

                // Album art
                Com.AlbumArt {
                    animationProgress: root.animationProgress
                }

                // Song info
                Com.SongInfo {
                    animationProgress: root.animationProgress
                }
            }

            // Controls
            Com.MusicControls {
                animationProgress: root.animationProgress
            }
            Com.MusicProgressBar {
                animationProgress: root.animationProgress
            }
        }
        Loader {
            anchors.fill: parent

            active: !heightAnim.running && !widthAnim.running

            sourceComponent: StarField {
                starCount: 10
                shootingStarCount: 2
            }
        }
    }
}
