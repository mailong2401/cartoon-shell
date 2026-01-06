import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Widgets


Rectangle {
    id: root
    
    property var theme: currentTheme
    property var config: currentConfig
    property string userName: config.dashboard.name
    property string userHandle: config.dashboard.username
    property string userAvatar: config.dashboard.avatar

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.button.border

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
        ClippingRectangle {
                            id: albumArtContainer
                            anchors.fill: parent
                            radius: width / 2
                            color: theme.primary.dim_background
                            border.color: theme.button.border
                            border.width: 3

            Image {
                anchors.fill: parent
                source: root.userAvatar
                fillMode: Image.PreserveAspectCrop
                smooth: true

            }
          }
        }

        // User Name
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: root.userName
            color: theme.primary.foreground
            font.pixelSize: 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }

        // User Handle
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: root.userHandle
            color: theme.primary.foreground
            font.pixelSize: 24
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}
