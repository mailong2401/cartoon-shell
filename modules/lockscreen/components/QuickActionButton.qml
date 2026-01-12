import QtQuick
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string icon: ""
    property color iconColor: "white"
    property var theme: currentTheme

    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.normal.black

    Label {
        anchors.centerIn: parent
        text: root.icon
        color: root.iconColor
        font.pixelSize: 24
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
