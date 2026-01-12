import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root

    Layout.preferredWidth: 200
    Layout.preferredHeight: 220
    radius: 28
    property var theme: currentTheme
    color: theme.primary.background

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        FileItem { icon: ""; label: "Documents"; iconColor: theme.primary.foreground }
        FileItem { icon: ""; label: "Downloads"; iconColor: theme.primary.foreground }
        FileItem { icon: ""; label: "Music"; iconColor: theme.primary.foreground }
        FileItem { icon: ""; label: "Pictures"; iconColor: theme.primary.foreground }
        FileItem { icon: ""; label: "~/.config"; iconColor: theme.primary.foreground }
        FileItem { icon: ""; label: "~/.local"; iconColor: theme.primary.foreground }
    }
}
