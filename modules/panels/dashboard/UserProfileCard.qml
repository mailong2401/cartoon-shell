import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Widgets
import qs.services
import qs.commons
import qs.components

Item {
    id: root

    property real animationProgress: 0

    Loader {
        source: "../../dialogs/FileDialog.qml"
        active: VisibleService.filedialog

        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.filedialog;
            });

            item.fileOpened.connect(function (fileUrl) {
                Settings.dashboard.urlAvatar = fileUrl;
                VisibleService.togglePanel("filedialog");
            });
        }
    }

    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle {
        anchors.centerIn: parent
        implicitWidth: root.animationProgress > 0.05 ? parent.width : 0
        implicitHeight: root.animationProgress > 0.05 ? parent.height : 0
        color: theme.primary.background
        radius: ScalerService.s(Settings.appearance.radius1)
        border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
        border.color: theme.button.border

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
                circleCount: 1
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(20)
            spacing: ScalerService.s(15)

            // Avatar
            Rectangle {
                id: avatarRoot

                Layout.alignment: Qt.AlignHCenter

                width: ScalerService.s(120)
                height: ScalerService.s(120)
                radius: ScalerService.s(60)

                color: "#2a2a2a"

                property bool hovered: false

                scale: hovered ? 1.05 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 120
                    }
                }

                ClippingRectangle {
                    id: albumArtContainer

                    opacity: root.animationProgress > 0.1 ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    anchors.fill: parent
                    radius: width / 2

                    color: theme.primary.dim_background

                    border.color: theme.primary.foreground

                    border.width: mouseAreaAvt.containsMouse ? ScalerService.s(2) : ScalerService.s(1)

                    Behavior on border.width {
                        NumberAnimation {
                            duration: 120
                        }
                    }

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 120
                        }
                    }

                    Image {
                        anchors.fill: parent
                        source: Settings.dashboard.urlAvatar ? Settings.dashboard.urlAvatar : "/home/long/Downloads/111423869.png"
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }
                    Rectangle {
                        anchors.fill: parent

                        color: "black"
                        opacity: mouseAreaAvt.containsMouse ? 0.4 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }
                        }
                    }
                    IconText {
                        visible: avatarRoot.hovered ? true : false
                        name: "frame_person"

                        anchors.centerIn: parent

                        font.pixelSize: mouseAreaAvt.containsMouse ? ScalerService.s(58) : ScalerService.s(52)

                        Behavior on font.pixelSize {
                            NumberAnimation {
                                duration: 150
                            }
                        }
                    }
                }

                MouseArea {
                    id: mouseAreaAvt
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: VisibleService.togglePanel("filedialog")

                    onEntered: avatarRoot.hovered = true
                    onExited: avatarRoot.hovered = false
                }
            }

            // User Name
            CustomText {
                Layout.alignment: Qt.AlignHCenter
                name: Settings.dashboard.fullname
                textColor: theme.button.text
                size: "xl"
                isBold: true
                opacity: root.animationProgress > 0.15 ? 1 : 0
            }

            // User Handle
            CustomText {
                Layout.alignment: Qt.AlignHCenter
                name: Settings.dashboard.username
                textColor: theme.primary.dim_foreground
                opacity: root.animationProgress > 0.2 ? 1 : 0
            }
        }
    }
}
