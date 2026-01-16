import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "." as Com

PanelWindow {
    id: wifiPanel
    property var sizes: currentSizes.wifiPanel || {}
    anchors{
      top: true
      bottom: true
      left: true
      right: true
    }
    
    color: "transparent"
    focusable: true
    Region {
      id: wifiMaskRegion
      item: contentRect
    }
    mask: {
      panelManager.wifiMask ? wifiMaskRegion : null
    }
    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: panelManager.closeAllPanels()
    }
    Com.WifiManager {
      id: wifiManager
    }

    property var theme: currentTheme
    property var lang: currentLanguage

    Rectangle {
      id: contentRect
      anchors {
            right: parent.right
            top: currentConfig.mainPanelPos === "top" ? parent.top : undefined
            bottom: currentConfig.mainPanelPos === "bottom" ? parent.bottom : undefined
        }

        anchors.rightMargin: 10
        anchors.topMargin: currentConfig.mainPanelPos === "top" ? 10 : 0
        anchors.bottomMargin: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        implicitWidth: sizes.width || 430
        implicitHeight: sizes.height || 800
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
