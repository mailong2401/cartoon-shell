import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

RowLayout {
    id: root
    property string icon: ""
    property string label: ""
    property color iconColor: "white"
    property var theme: currentTheme

    Layout.fillWidth: true
    spacing: 10

    Label {
        text: root.icon
        color: theme.primary.foreground
        font.pixelSize: 16
    }

    Label {
        text: root.label
        color: theme.primary.foreground
        font.pixelSize: 11
    }
}
