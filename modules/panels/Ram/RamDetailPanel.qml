import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: root

    implicitWidth: 930
    implicitHeight: 960

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
        left: true
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? 10 : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        left: Math.round((Quickshell.screens.primary?.width ?? 1920) / 2 - implicitWidth / 2)
    }

    exclusiveZone: 0
    color: "transparent"

    property var theme : currentTheme
    property var lang : currentLanguage
    
    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 8
        border.color: theme.button.border
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 30

            Components.RamDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
            }

            Components.RamDisplay {
                Layout.fillWidth: true
                Layout.preferredHeight: 330
            }

            Components.RamTaskManager {
                Layout.fillWidth: true
                Layout.preferredHeight: 500
            }

        }
    }
}
