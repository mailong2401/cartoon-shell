import QtQuick
import QtQuick.Layouts

Item {
    id: headerCard

    property var theme: currentTheme
    property var lang: currentLanguage

    Layout.fillWidth: true
    height: 70

    Text {
        text: lang?.weather?.title || "Thời Tiết"
        color: theme.primary.foreground
        font {
            pixelSize: 40
            bold: true
            family: "ComicShannsMono Nerd Font"
        }
        anchors.centerIn: parent
    }
}
