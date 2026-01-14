import QtQuick
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string icon: ""
    property int size: 35
    property color backgroundColor: "transparent"
    property var onButtonClicked: function() {}
    property var theme: currentTheme

    width: size
    height: size
    radius: size / 2
    color: backgroundColor

    Label {
        anchors.centerIn: parent
        text: root.icon
        color: root.backgroundColor === "transparent" ? "#8899bb" : "white"
        font.pixelSize: root.size * 0.5
        font.family: "ComicShannsMono Nerd Font"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.onButtonClicked()
    }
}
