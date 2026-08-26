import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import qs.services
import qs.components
import qs.commons

Item {
    id: root
    property int count: 230
    property int index: 0

    Layout.fillWidth: true
    Layout.fillHeight: true

    SequentialAnimation on index {
        running: root.animationProgress > 0.9

        PauseAnimation {
            duration: 200
        }

        NumberAnimation {
            to: root.count
            duration: 400
            easing.type: Easing.OutCubic
        }
    }
    property real animationProgress: 0

    Rectangle {
        anchors.centerIn: parent
        implicitWidth: root.animationProgress > 0.6 ? parent.width : 0
        implicitHeight: root.animationProgress > 0.6 ? parent.height : 0
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

            IconImage {
                path: "workspace/pacman/active.png"
                size: "xl"
                opacity: root.animationProgress > 0.8 ? 1 : 0
            }
            Item {
                Layout.fillWidth: true
            }
            CustomText {
                name: index
                isBold: true
                opacity: root.animationProgress > 0.85 ? 1 : 0
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                VisibleService.togglePanel("packagePanel");
            }
        }
    }
}
