import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell
import qs.commons
import qs.components
import qs.services
import qs.services.ram
import qs.services.cpu

Item {
    id: root
    implicitWidth: ScalerService.s(480)
    implicitHeight: ScalerService.s(220)
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
            CustomText {
                name: "System usage"
                size: "xl"
                isBold: true
                textColor: theme.button.text
                Layout.alignment: Qt.AlignHCenter
            }
            RowLayout {
                anchors.fill: parent
                anchors.margins: ScalerService.s(20)
                spacing: ScalerService.s(20)
                CircularUsage {
                    title: "CPU"
                    value: CpuSimpleService.cpuPercent
                    progressColor: theme.normal.red
                    implicitWidth: 130
                    implicitHeight: 180
                }
                CircularUsage {
                    title: "Ram"
                    value: RamSimpleService.ramPercent
                    progressColor: theme.normal.green
                    implicitWidth: 130
                    implicitHeight: 180
                }
                CircularUsage {
                    title: "Disk"
                    value: DiskService.diskPercents
                    progressColor: theme.normal.blue
                    implicitWidth: 130
                    implicitHeight: 180
                }
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
