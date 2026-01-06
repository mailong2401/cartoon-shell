import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

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
    Process {
        id: cpuUsageProcess
        command: ["bash", "-c", "mpstat 1 1 | awk '/Average/ && $2==\"all\" { printf \"%.1f%%\\n\", 100-$12 }'"]
        stdout: StdioCollector {
            onTextChanged: {
                if (this.text) {
                    parseCpuUsage(this.text)
                }
            }
        }
    }

    function parseCpuUsage(text) {
        if (!text) return;
        var lines = text.trim().split('\n');
        if (lines.length > 0) {
            var usageStr = lines[0].trim();
            var usage = parseFloat(usageStr);
            if (!isNaN(usage)) {
                cpuUsage = usage.toFixed(1) + "%";
                
                var newHistory = cpuHistory.slice();
                newHistory.push({
                    timestamp: new Date().getTime(),
                    usage: usage  // Chỉ lưu giá trị tổng
                });
                
                if (newHistory.length > maxHistoryLength) {
                    newHistory.shift();
                }
                cpuHistory = newHistory;
            }
        }
    }

    function getUsageColor(usageStr) {
        var usage = parseFloat(usageStr);
        if (usage >= 80) return "#e74c3c";
        if (usage >= 60) return "#f39c12";
        if (usage >= 40) return "#f1c40f";
        if (usage >= 20) return "#2ecc71";
        return "#3498db";
    }

    function getMaxUsage() {
        if (cpuHistory.length === 0) return "0.0";
        var max = 0;
        for (var i = 0; i < cpuHistory.length; i++) {
            var usage = cpuHistory[i].usage;
            if (!isNaN(usage) && usage > max) {
                max = usage;
            }
        }
        return max.toFixed(1);
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
                getUsageColor: detailPanel.getUsageColor
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
