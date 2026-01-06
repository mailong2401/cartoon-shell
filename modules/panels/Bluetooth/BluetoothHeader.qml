// Header component for Bluetooth panel
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: header
    required property var adapter
    required property var theme
    required property var lang
    required property bool isDiscovering

    signal scanClicked()

    Layout.fillWidth: true
    height: 100
    radius: 12
    color: theme.primary.background

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Bluetooth icon
        Rectangle {
            width: 64
            height: 64
            radius: 20
            color: theme.primary.background

            Image {
                source: "../../../assets/settings/bluetooth.png"
                width: 64
                height: 64
                sourceSize: Qt.size(64, 64)
                anchors.centerIn: parent
            }
        }

        // Title
        ColumnLayout {
            spacing: 4
            Layout.fillWidth: true

            Text {
                text: "Bluetooth"
                color: theme.primary.foreground
                font.pixelSize: 40
                font.family: "ComicShannsMono Nerd Font"
                font.weight: Font.Bold
            }
        }

        Item { Layout.fillWidth: true }

        // Scan button
        Rectangle {
            id: scanButton
            Layout.preferredWidth: 55
            Layout.preferredHeight:55
            radius: 28
            visible: adapter?.enabled || false
            color: {
                if (isDiscovering) return theme.normal.red
                if (scanButtonMouse.containsMouse) return theme.normal.blue
                return theme.primary.dim_foreground
            }

            scale: scanButtonMouse.containsPress ? 0.95 : (scanButtonMouse.containsMouse ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 200 } }

            Image {
                source: "../../../assets/launcher/search.png"
                width: 40
                height: 40
                sourceSize: Qt.size(40, 40)
                anchors.centerIn: parent
            }

            // Scanning animation
            Rectangle {
                anchors.fill: parent
                radius: 28
                color: "transparent"
                border.width: 2
                border.color: theme.normal.green
                visible: isDiscovering
                rotation: scanRotation

                RotationAnimator on rotation {
                    id: scanRotation
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: isDiscovering
                }

                Rectangle {
                    width: 4
                    height: 4
                    radius: 2
                    color: theme.normal.green
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: -2
                }
            }

            MouseArea {
                id: scanButtonMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: header.scanClicked()
            }
        }
    }
}
