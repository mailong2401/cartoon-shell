// components/Settings/ThemeSelection.qml
import QtQuick
import QtQuick.Layouts
import "." as Com

RowLayout {
    id: themeSelection
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig
    property var matugenHandler
    
    spacing: 12

    Text {
        text: lang.appearance?.theme_label || "Chủ đề:"
        color: theme.primary.foreground
        font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 16
        }
        Layout.preferredWidth: 150
    }

    Row {
        spacing: 12
        Layout.fillWidth: true

        // Light Theme Card
        Com.ThemeCard {
            type: "light"
            isSelected: theme.type === "light"
            label: lang.appearance?.theme_light || "Sáng"
            theme: themeSelection.theme
            onClicked: {
                panelConfig.set("theme", "light")
                Qt.callLater(matugenHandler.triggerMatugenOnThemeChange("light"))
            }
        }

        // Dark Theme Card
        Com.ThemeCard {
            type: "dark"
            isSelected: theme.type === "dark"
            label: lang.appearance?.theme_dark || "Tối"
            theme: themeSelection.theme
            onClicked: {
                panelConfig.set("theme", "dark")
                Qt.callLater(matugenHandler.triggerMatugenOnThemeChange("dark"))
            }
        }
    }
}
