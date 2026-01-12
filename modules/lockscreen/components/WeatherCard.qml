import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string weatherCondition: "Clear Sky"
    property string weatherDescription: "It's a clear night\nYou might want to take a evening stroll to relax..."
    property int temperature: 35
    property string weatherIcon: "🌙"
    property var theme: currentTheme

    Layout.preferredWidth: 400
    Layout.preferredHeight: 240
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.normal.black

    RowLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20

        Label {
            text: root.weatherIcon
            font.pixelSize: 72
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10

            Label {
                text: root.temperature + "°C"
                color: theme.primary.foreground
                font.pixelSize: 42
                font.bold: true
            }

            Label {
                text: root.weatherCondition
                color: theme.primary.foreground
                font.pixelSize: 16
                font.bold: true
            }

            Label {
                Layout.fillWidth: true
                text: root.weatherDescription
                color: theme.primary.foreground
                font.pixelSize: 10
                wrapMode: Text.WordWrap
            }
        }
    }
}
