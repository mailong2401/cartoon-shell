import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "." as Com

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

        Com.FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/documents_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/documents_light.png"
          label: "Documents"
          iconColor: theme.normal.red
        }
        Com.FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/downloads_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/downloads_light.png"
          label: "Downloads"
          iconColor: theme.normal.green
        }
        Com.FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/music_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/music_light.png"
          label: "Musics"
          iconColor: theme.normal.yellow
        }
        Com.FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/pictures_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/pictures_light.png"
          label: "Pictures"
          iconColor: theme.normal.blue
        }
        Com.FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/config_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/config_light.png"
          label: "~/.config"
          iconColor: theme.normal.cyan
        }
        Com.FileItem {
          iconDark: "../../../assets/lockscreen/filebrowser/local_dark.png"
          iconLight: "../../../assets/lockscreen/filebrowser/local_light.png"
          label: "~/.local"
          iconColor: theme.bright.red
        }
    }
}
