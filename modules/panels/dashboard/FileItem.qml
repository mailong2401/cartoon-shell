import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string iconDark: ""
    property string iconLight: ""
    property string label: ""
    property color iconColor: "white"
    property var theme: currentTheme
    property var sizes: currentSizes

    Layout.fillWidth: true
    Layout.preferredHeight: 35
    radius: 12
    color: mouseArea.containsMouse ? Qt.rgba(iconColor.r, iconColor.g, iconColor.b, 0.1) : "transparent"

    Behavior on color {
        ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 10

        Image {
            id: itemIcon
            source: theme.type === "dark" ? root.iconDark : root.iconLight
            Layout.preferredWidth: sizes.iconSize?.large || 30
            Layout.preferredHeight: sizes.iconSize?.large || 30
            fillMode: Image.PreserveAspectFit
            smooth: true
            scale: mouseArea.containsMouse ? 1.1 : 1.0

            Behavior on scale {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
        }

        Label {
            id: itemLabel
            text: root.label
            color: iconColor
            font.family: "ComicShannsMono Nerd Font"
            font.pixelSize: sizes.fontSize?.medium || 16
            font.bold: mouseArea.containsMouse

            Behavior on font.bold {
                PropertyAnimation { duration: 150 }
            }
        }

        Item { Layout.fillWidth: true }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            // Add click action here
            console.log("Clicked:", root.label)
        }
    }
}
