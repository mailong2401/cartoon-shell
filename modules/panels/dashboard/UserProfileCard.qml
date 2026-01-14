import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string userName: "Long"
    property string userHandle: "@mailong2401"
    property string userAvatar: "/home/long/Pictures/Wallpapers/slide_4.jpg"
    property var theme: currentTheme
    property var sizes: currentSizes

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

            }
        }

        // User Name
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: root.userName
            color: theme.primary.foreground
            font.pixelSize: sizes.fontSize?.title
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }

        // User Handle
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: root.userHandle
            color: theme.primary.foreground
            font.pixelSize: sizes.fontSize?.large
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}
