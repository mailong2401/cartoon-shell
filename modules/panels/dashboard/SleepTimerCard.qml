import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root

    property var theme: currentTheme

    Layout.fillWidth: true
    Layout.preferredHeight: 120
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.button.border

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Label {
            text: ""
            color: theme.primary.foreground
            font.pixelSize: 48
            font.family: "ComicShannsMono Nerd Font"
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            Label {
                text: "9 hours"
                color: theme.primary.foreground
                font.family: "ComicShannsMono Nerd Font"
                font.pixelSize: 20
                font.bold: true
            }

            Label {
                text: "55 minutes"
                font.family: "ComicShannsMono Nerd Font"
                color: theme.primary.foreground
                font.pixelSize: 16
            }
        }
    }
}
