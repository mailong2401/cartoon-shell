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

        FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/documents_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/documents_light.png"
          label: "Documents"
          iconColor: theme.normal.red
        }
        FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/downloads_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/downloads_light.png"
          label: "Downloads"
          iconColor: theme.normal.green
        }
        FileItem { iconDark: "";iconLight: ""; label: "Music"; iconColor: theme.primary.foreground }
        FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/pictures_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/pictures_light.png"
          label: "Pictures"
          iconColor: theme.normal.blue
        }
        FileItem { iconDark: "";iconLight: ""; label: "~/.config"; iconColor: theme.primary.foreground }
        FileItem { iconDark: "";iconLight: ""; label: "~/.local"; iconColor: theme.primary.foreground }
    }
}
