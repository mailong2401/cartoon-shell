import QtQuick

Item {
    id: header
    signal closeClicked()

    property var theme: currentTheme
    property var lang: currentLanguage

    Row {
        anchors.centerIn: parent
        spacing: 20
        Text {
            text: lang?.ram?.panel_title || "Quản lí Ram"
            color: theme.primary.foreground
            font.pixelSize: 40
            font.bold: true
            font.family: "ComicShannsMono Nerd Font"
        }
    }
}
