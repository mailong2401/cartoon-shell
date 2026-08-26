import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components
import qs.commons

RowLayout {
    id: root
    property string nameIcon: ""
    property color iconColor: "white"
    property real animationProgress: 0
    property real revealThreshold: 0.6

    property real value: 0.5

    Layout.fillWidth: true
    spacing: ScalerService.s(10)

    // Icon button (left)
    Item {
        Layout.preferredWidth: ScalerService.s(50)
        Layout.preferredHeight: ScalerService.s(50)
        Rectangle {
            anchors.centerIn: parent
            implicitWidth: root.animationProgress > root.revealThreshold - 0.1 ? parent.width : 0
            implicitHeight: root.animationProgress > root.revealThreshold - 0.1 ? parent.height : 0
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

            IconText {
                name: root.nameIcon
                size: "normal"
                anchors.centerIn: parent
                color: root.iconColor
                opacity: root.animationProgress > root.revealThreshold ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }
        }
    }

    // Slider bar (right)
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: ScalerService.s(50)
        Rectangle {
            anchors.centerIn: parent
            implicitWidth: root.animationProgress > root.revealThreshold - 0.05 ? parent.width : 0
            implicitHeight: root.animationProgress > root.revealThreshold - 0.05 ? parent.height : 0
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

            Rectangle {
                anchors.fill: parent
                anchors.margins: ScalerService.s(8)
                radius: ScalerService.s(17)
                color: theme.primary.background

                Rectangle {
                    height: parent.height
                    width: root.animationProgress > root.revealThreshold + 0.03 ? parent.width * root.value : 0
                    Behavior on width {
                        NumberAnimation {
                            duration: 500
                        }
                    }
                    radius: parent.radius
                    color: root.iconColor
                }
            }
        }
    }
}
