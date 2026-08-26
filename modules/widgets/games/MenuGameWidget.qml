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
    implicitHeight: ScalerService.s(350)
    property real animationProgress: 0
    property string view: "menu"
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
            active: !heightAnim.running && !widthAnim.running && root.view === "menu"
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

        // ---- Menu ----
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(20)
            spacing: ScalerService.s(20)
            visible: root.view === "menu"

            CustomText {
                name: "Game"
                isBold: true
                size: "xl"
                Layout.alignment: Qt.AlignHCenter
                textColor: theme.button.text
            }
            ButtonText {
                name: "Pacman"
                Layout.fillWidth: true
                onClicked: root.view = "pacman"
            }
            ButtonText {
                name: "Caro"
                Layout.fillWidth: true
                onClicked: root.view = "caro"
            }
            ButtonText {
                name: "Snake"
                Layout.fillWidth: true
                onClicked: root.view = "caro"
            }
            Item {
                Layout.fillHeight: true
            }
        }

        // ---- Pacman ----
        Loader {
            anchors.fill: parent
            anchors.margins: ScalerService.s(20)
            active: root.view === "pacman"
            sourceComponent: Com.PacmanGame {
                onBackRequested: root.view = "menu"
            }
        }

        Loader {
            anchors.fill: parent
            active: !heightAnim.running && !widthAnim.running && root.view === "menu"
            sourceComponent: StarField {
                starCount: 10
                shootingStarCount: 2
            }
        }
    }
}
