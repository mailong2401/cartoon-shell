import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

RowLayout {
    id: root
    property string icon: ""
    property color iconColor: "white"
    property var theme: currentTheme
    property real value: 0.5

    Layout.fillWidth: true
    spacing: 10

    // Icon button (left)
    Rectangle {
        Layout.preferredWidth: 50
        Layout.preferredHeight: 50
        radius: 25
        color: root.iconColor
        border.width: 3
        border.color: theme.normal.black

        Label {
            anchors.centerIn: parent
            text: root.icon
            color: theme.primary.foreground
            font.pixelSize: 24
            font.family: "ComicShannsMono Nerd Font"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    // Slider bar (right)
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        radius: 25
        color: theme.primary.background
        border.width: 3
        border.color: "#26ffffff"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 8
            radius: 17
            color: "#555"

            Rectangle {
                height: parent.height
                width: parent.width * root.value
                radius: parent.radius
                color: root.iconColor
            }
        }
    }
}
