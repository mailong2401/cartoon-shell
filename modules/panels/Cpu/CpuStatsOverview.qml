import QtQuick

Rectangle {
    property var calculateTotalUsage: function() { return "0.0" }
    property var getMaxUsage: function() { return "0.0" }
    property var getUsageColor: function(usageStr) { return "#3498db" }
    property var cpuHistory: []
    property var theme: currentTheme
    property var lang: currentLanguage

    color: theme.primary.dim_background
    border.color: theme.button.border
    border.width: 2
    radius: 4

    Row {
        anchors.centerIn: parent
        spacing: 40

        Row {
            Image {
                width: 40
                height: 40
                source: '../../../assets/cpu/pie-chart.png'
            }
            Column {
                spacing: 2
                Text {
                    text: lang.cpuStats.totalUsage
                    color: "#4f4f5b"
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                }
                Text {
                    text: calculateTotalUsage() + "%"
                    color: getUsageColor(calculateTotalUsage())
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }

        Row {
            Image {
                width: 40
                height: 40
                source: '../../../assets/cpu/fire.png'
            }
            Column {
                spacing: 2
                Text {
                    text: lang.cpuStats.maxCore
                    color: "#4f4f5b"
                    font.pixelSize: 16
                    font.family: "ComicShannsMono Nerd Font"
                }
                Text {
                    text: getMaxUsage() + "%"
                    color: getUsageColor(getMaxUsage())
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }

        Column {
            spacing: 2
            Text {
                text: lang.cpuStats.timeLabel
                color: "#4f4f5b"
                font.pixelSize: 14
                font.family: "ComicShannsMono Nerd Font"
            }
            Text {
                text: cpuHistory.length + " " + lang.cpuStats.dataPoints
                color: "#4f4f5b"
                font.pixelSize: 18
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
            }
        }
    }
}
