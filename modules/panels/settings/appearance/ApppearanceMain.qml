// components/Settings/AppearanceSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "." as Com
import "../../services"

Item {
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig  // Received from parent SettingsPanel
    id: root
    
    Matugen {
        id: matugenHandler
    }
    
    // Hàm helper để set position
    function setClockPosition(position) {
        panelConfig.set("clockPanelPosition", position)
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 20

            Text {
                text: lang.appearance?.title || "Giao diện"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 24
                    bold: true
                }
                Layout.topMargin: 10
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.foreground
            }

            // Theme Selection
            ThemeSelection {
                theme: root.theme
                lang: root.lang
                panelConfig: root.panelConfig
                matugenHandler: matugenHandler
                Layout.fillWidth: true
            }

            // Clock Panel Visibility
            ClockPanelToggle {
                theme: root.theme
                lang: root.lang
                panelConfig: root.panelConfig
                Layout.fillWidth: true
            }

            // Panel Position Selection
            PanelPositionSelector {
                theme: root.theme
                lang: root.lang
                panelConfig: root.panelConfig
                Layout.fillWidth: true
            }

            // Clock Position Selection
            ClockPositionSelector {
                theme: root.theme
                lang: root.lang
                currentConfig: currentConfig
                onPositionSelected: root.setClockPosition(position)
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }
        }
    }

    Component.onCompleted: {
        console.log("AppearanceSettings loaded")
    }
}
