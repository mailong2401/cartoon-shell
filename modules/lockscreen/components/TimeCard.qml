import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root

    Layout.fillWidth: true
    Layout.preferredHeight: 120
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.normal.black
    property var theme: currentTheme

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Time
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            RowLayout {
                spacing: 10
                Label {
                    id: timeLabel
                    property var currentTime: new Date()
                    text: Qt.formatTime(currentTime, "hh")
                    color: theme.primary.foreground
                    font.pixelSize: 48
                    font.bold: true

                    Timer {
                        running: true
                        repeat: true
                        interval: 1000
                        onTriggered: timeLabel.currentTime = new Date()
                    }
                }

                Label {
                    text: Qt.formatTime(timeLabel.currentTime, "mm")
                    color: theme.primary.foreground
                    font.pixelSize: 48
                    font.bold: true
                }
            }

            Label {
                text: Qt.formatTime(timeLabel.currentTime, "AP") + "\n" +
                      Qt.formatDate(timeLabel.currentTime, "dddd")
                color: theme.primary.foreground
                font.pixelSize: 12
            }
        }

        // Moon icon
        Label {
            text: "🌙"
            font.pixelSize: 64
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
