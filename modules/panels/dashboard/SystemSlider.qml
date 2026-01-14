import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

RowLayout {
    id: root
    property string iconDark: ""
    property string iconLight: ""
    property color iconColor: "white"
    property var theme: currentTheme
    property var sizes: currentSizes
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

        Image {
            source: theme.type === "dark" ? iconDark : iconLight
            width: sizes.iconSize?.medium || 30
            height: sizes.iconSize?.medium || 30
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            smooth: true
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
            color: theme.primary.background

            Rectangle {
                height: parent.height
                width: parent.width * root.value
                radius: parent.radius
                color: root.iconColor
            }
        }
    }
}
