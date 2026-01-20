import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components
import "../../../services/" as Service

PanelWindow {
    id: detailPanel

    implicitWidth: 1030
    implicitHeight: 850

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

    signal closeRequested()

    property var cpuHistory: []
    property int maxHistoryLength: 50
    property var theme: currentTheme
    property string cpuUsage: "0%"  // Tổng CPU usage

    // Process để lấy CPU usage tổng
    Service.CpuUsageService {
        id: cpuUsageService
    }

    // Cập nhật lịch sử CPU từ service
    function updateCpuHistory() {
        if (!cpuUsageService.cpuPercent) return;
        
        var usage = cpuUsageService.cpuPercent;
        var newHistory = cpuHistory.slice();
        
        newHistory.push({
            timestamp: new Date().getTime(),
            usage: usage
        });
        
        if (newHistory.length > maxHistoryLength) {
            newHistory.shift();
        }
        cpuHistory = newHistory;
    }




    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 8
        border.color: theme.button.border
        border.width: 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            // Header với nút đóng
            Components.CpuDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
            }

            // Thông tin CPU
            Components.CpuInfoSection {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
            }

            // BIỂU ĐỒ CPU USAGE
            Components.CpuUsageChart {
                Layout.fillWidth: true
                Layout.fillHeight: true
                cpuHistory: detailPanel.cpuHistory
            }
        }
    }

    Timer {
        interval: 500
        running: detailPanel.visible
        repeat: true
        onTriggered: {
            cpuUsageProcess.running = true;
        }
    }

    Component.onCompleted: {
        if (detailPanel.visible) {
            cpuUsageProcess.running = true;
        }
    }
}
