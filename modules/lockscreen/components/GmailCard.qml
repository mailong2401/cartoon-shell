import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property int emailCount: 230
    property var theme: currentTheme

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.normal.black

    RowLayout {
        anchors.centerIn: parent
        spacing: 20

        Label {
            text: ""
            color: "#ea4335"
            font.pixelSize: 48
        }

        Label {
            text: root.emailCount.toString()
            color: "#333333"
            font.pixelSize: 36
            font.bold: true
        }
    }
}
