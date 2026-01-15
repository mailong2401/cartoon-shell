import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts

Rectangle {
    id: root
    property string icon: ""
    property color iconColor: "white"
    property var theme: currentTheme
    property var sizes: currentSizes

    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.button.border

    Image {
        id: iconImage
        source: root.icon
        anchors.centerIn: parent
        width: sizes.iconSize?.xlarge || 50
        height: sizes.iconSize?.xlarge || 50
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: status === Image.Ready

        // Debug placeholder
        Text {
            anchors.centerIn: parent
            text: "?"
            color: theme.primary.dim_foreground
            font.pixelSize: 24
            font.family: "ComicShannsMono Nerd Font"
            visible: parent.status !== Image.Ready
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
