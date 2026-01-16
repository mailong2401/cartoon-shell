import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "." as Com

PanelWindow {
    id: wifiPanel
    property var sizes: currentSizes.wifiPanel || {}

    implicitWidth: sizes.width || 430
    implicitHeight: sizes.height || 800

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
        radius: sizes.radius || 10
        color: theme.primary.background
        border.width: sizes.borderWidth || 2
        border.color: theme.button.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 16
            spacing: sizes.spacing || 12

            Com.WifiHeader {
                Layout.fillWidth: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
            }

            Com.WifiStatus {
                Layout.fillWidth: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
            }

            Com.WifiNetworkList {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                wifiManager: wifiManager
                visible: wifiManager.wifiEnabled
            }

            Com.WifiEmptyState {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sizes: wifiPanel.sizes
                theme: wifiPanel.theme
                lang: wifiPanel.lang
                visible: !wifiManager.wifiEnabled
            }
        }
    }
}
