import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    property string userName: "Aditya Shakya"
    property string userHandle: "@adi1090x"
    property string userAvatar: "/home/long/Pictures/avatar.jpg"
    property var theme: currentTheme

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.normal.black

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Avatar
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 120
            height: 120
            radius: 60
            color: "#2a2a2a"

            Image {
                anchors.fill: parent
                source: root.userAvatar
                fillMode: Image.PreserveAspectCrop
                smooth: true
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: 120
                        height: 120
                        radius: 60
                    }
                }
            }
        }

        // User Name
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: root.userName
            color: theme.primary.foreground
            font.pixelSize: 18
            font.bold: true
        }

        // User Handle
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: root.userHandle
            color: theme.primary.foreground
            font.pixelSize: 12
        }
    }
}
