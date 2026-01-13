import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string icon: ""
    property color bgColor: "white"
    property var theme: currentTheme

    Layout.fillHeight: true
    Layout.preferredWidth: height
    radius: 22
    color: bgColor
    border.width: 3
    border.color: theme.normal.black

    Label {
        anchors.centerIn: parent
        text: root.icon
        color: theme.primary.foreground
        font.pixelSize: 22
        font.family: "ComicShannsMono Nerd Font"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
