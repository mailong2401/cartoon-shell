import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import qs.services
import qs.components
import qs.commons

Item {
    id: root

    property real animationProgress: 0

    Layout.fillWidth: true
    Layout.preferredHeight: ScalerService.s(120)

    clip: true

    Rectangle {
        anchors.centerIn: parent
        implicitWidth: root.animationProgress > 0.25 ? parent.width : 0
        implicitHeight: root.animationProgress > 0.25 ? parent.height : 0
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
        Behavior on implicitWidth {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
        color: theme.primary.background
        radius: ScalerService.s(Settings.appearance.radius1)
        border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
        border.color: theme.button.border

        RowLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(20)
            spacing: ScalerService.s(15)

            // Phần hiển thị thời gian (giờ và phút)
            ColumnLayout {
                spacing: ScalerService.s(2)
                CustomText {
                    name: DateTimeService.currentHour
                    size: "large"
                    isBold: true
                    opacity: root.animationProgress > 0.4 ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }

                CustomText {
                    name: DateTimeService.currentMinus
                    size: "large"
                    isBold: true
                    opacity: root.animationProgress > 0.43 ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: ScalerService.s(4)
                Layout.preferredHeight: root.animationProgress > 0.47 ? ScalerService.s(70) : 0
                color: theme.primary.foreground
                radius: ScalerService.s(2)
                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: 500
                    }
                }
            }

            // Phần hiển thị ngày tháng
            ColumnLayout {
                Layout.fillWidth: true
                spacing: ScalerService.s(2)
                CustomText {
                    name: DateTimeService.currentDay
                    isBold: true
                    opacity: root.animationProgress > 0.5 ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }
                CustomText {
                    name: `${DateTimeService.currentOfDays} ${DateTimeService.currentMonth} ${DateTimeService.currentYear}`
                    size: "small"
                    isBold: true
                    opacity: root.animationProgress > 0.55 ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }
            }
        }
    }
}
