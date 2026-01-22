import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./theme" as Com
import qs.services


Item{
property var theme: currentTheme
property var lang: currentLanguage
property var panelConfig

Matugen {
        id: matugenHandler
    }

ScrollView {
    clip: true
    ColumnLayout {
        width: parent.width
        spacing: 20

        Text {
            text: lang.appearance?.theme || "Theme"
            color: theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: 24
                bold: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: theme.primary.foreground
            opacity: 0.3
        }

        // Nội dung Theme ở đây
        Text {
            text: "Theme settings content"
            color: theme.primary.foreground
        }
        Com.ThemeSelection{
          panelConfig: root.panelConfig
          matugenHandler: matugenHandler
        }
    }
}
}
