import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string icon: ""
    property color iconColor: "white"
    property var theme: currentTheme

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 18
    color: theme.primary.background

    Label {
        anchors.centerIn: parent
        text: root.icon
        color: root.iconColor
        font.pixelSize: 28
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
