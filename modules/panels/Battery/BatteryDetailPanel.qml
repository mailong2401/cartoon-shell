import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: batteryDetailPanel

    property var sizes: currentSizes.batteryDetailPanel || {}
    property var theme: currentTheme

    anchors{
      top: true
      bottom: true
      left: true
      right: true
    }
    Region {
      id: batteryMaskRegion
      item: contentRect
    }
    mask: {
      panelManager.batteryMask ? batteryMaskRegion : null
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: panelManager.closeAllPanels()
    }
    
    color: "transparent"

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
      width: sizes.width || 430
    height: sizes.height || 400
        color: theme.primary.background
        radius: sizes.radius || 8
        border.color: theme.normal.black
        border.width: sizes.borderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 16
            spacing: sizes.spacing || 16

            // Header
            Text {
                text: "🔋 Battery Details"
                font.family: "ComicShannsMono Nerd Font"
                color: theme.primary.foreground
                font.bold: true
                font.pixelSize: sizes.headerFontSize || 16
                Layout.alignment: Qt.AlignHCenter
            }

            // Battery Panel Component
            Components.BatteryPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Timer {
        interval: 2000
        running: batteryDetailPanel.visible
        repeat: true
        onTriggered: {
            // Refresh data khi panel hiển thị
        }
    }

    Component.onCompleted: {
        // Khởi tạo dữ liệu
    }
}
