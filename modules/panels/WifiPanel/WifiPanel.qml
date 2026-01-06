import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "." as Com

PanelWindow {
    id: wifiPanel

    implicitWidth: 450
    implicitHeight: 800

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
        right: true
      }
      margins {
        top: currentConfig.mainPanelPos === "top" ? 10 : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        right: 10
    }
    
    color: "transparent"
    focusable: true
    Com.WifiManager {
      id: wifiManager
    }

    property var theme: currentTheme
    property var lang: currentLanguage

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: theme.primary.background
        border.width: 2
        border.color: theme.button.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Com.WifiHeader {
                Layout.fillWidth: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
            }

            Com.WifiStatus {
                Layout.fillWidth: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
            }

            Com.WifiNetworkList {
                Layout.fillWidth: true
                Layout.fillHeight: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
                visible: wifiManager.wifiEnabled
            }

            Com.WifiEmptyState {
                Layout.fillWidth: true
                Layout.fillHeight: true
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                visible: !wifiManager.wifiEnabled
            }
        }
    }
}
