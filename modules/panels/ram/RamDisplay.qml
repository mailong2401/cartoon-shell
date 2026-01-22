import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io
import Quickshell
import qs.services

Item {
    id: ramDisplay
    property var lang: currentLanguage
    property color usedRamColor: theme.normal.green
    property color freeRamColor: theme.normal.black
    property color usedSwapColor: theme.normal.blue
    property color freeSwapColor: theme.normal.black
    property color textColor: theme.primary.foreground
    property color dimTextColor: theme.primary.dim_foreground
    property color borderColor: theme.button.border
    property color separatorColor: theme.normal.black
    
    RamService{
      id: ramService
      useSimpleCalculation: false
    }

    property bool dataLoaded: true

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 12
        border.color: borderColor
        border.width: 2
        
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            opacity: 0.1
            radius: 12
            
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = theme.primary.foreground
                    ctx.lineWidth = 0.5
                    
                    for (var x = 0; x < width; x += 15) {
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }
                    for (var y = 0; y < height; y += 15) {
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: lang?.ram?.memory_monitor || "Memory Monitor"
                font.family: "ComicShannsMono Nerd Font"
                color: textColor
                font.bold: true
                font.pixelSize: 30
            }
            
            Item { Layout.fillWidth: true }
            
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: ramService.memPercent > 80 ? theme.normal.red : 
                       ramService.memPercent > 60 ? theme.normal.yellow : theme.normal.green
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "RAM"
                        color: textColor
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 24
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        text: ramService.memPercent + "%"
                        color: getUsageColor(ramService.memPercent)
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 24
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 20
                    radius: 10
                    color: freeRamColor

                    Rectangle {
                        width: parent.width * (ramService.memPercent / 100)
                        height: parent.height
                        radius: 10
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(usedRamColor, 1.2) }
                            GradientStop { position: 1.0; color: usedRamColor }
                        }
                        Behavior on width { 
                            NumberAnimation { 
                                duration: 800; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: ramService.memUsed + " / " + ramService.memTotal+ " MB"
                        color: theme.primary.background
                        font.bold: true
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 4
                columnSpacing: 8

                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: lang?.ram?.used || "Used"
                        color: dimTextColor
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: ramService.memUsed + " MB"
                        color: theme.normal.red
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                  }
                Item { Layout.preferredWidth: 20 }


                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: lang?.ram?.free || "Free"
                        color: dimTextColor
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: ramService.memFree + " MB"
                        color: theme.normal.green
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }

            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "transparent"
            
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.8
                height: 1
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.2; color: separatorColor }
                    GradientStop { position: 0.8; color: separatorColor }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "SWAP"
                        color: textColor
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 24
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    Text {
                        text: ramService.swapPercent + "%"
                        color: getUsageColor(ramService.swapPercent)
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 24
                        opacity: ramService.swapTotal > 0 ? 1 : 0.3
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 14
                    radius: 7
                    color: freeSwapColor
                    opacity: ramService.swapTotal > 0 ? 1 : 0.3

                    Rectangle {
                        width: parent.width * (ramService.swapPercent / 100)
                        height: parent.height
                        radius: 7
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(usedSwapColor, 1.2) }
                            GradientStop { position: 1.0; color: usedSwapColor }
                        }
                        Behavior on width { 
                            NumberAnimation { 
                                duration: 800; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: ramService.swapTotal > 0 ? (ramService.swapUsed + " / " + ramService.swapTotal + " MB") : (lang?.ram?.no_swap || "No SWAP")
                        color: theme.primary.background
                        font.bold: true
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 2
                columnSpacing: 8
                opacity: ramService.swapTotal > 0 ? 1 : 0.3
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: (lang?.ram?.used || "Used") + ":"
                        color: dimTextColor
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: ramService.swapUsed + " MB"
                        color: theme.normal.blue
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }

                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        text: (lang?.ram?.free || "Free") + ":"
                        color: dimTextColor
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    Text {
                        text: ramService.swapFree + " MB"
                        color: theme.normal.green
                        font.pixelSize: 20
                        font.family: "ComicShannsMono Nerd Font"
                        font.bold: true
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: 12
        opacity: dataLoaded ? 0 : 1
        visible: opacity > 0
        
        Behavior on opacity { NumberAnimation { duration: 300 } }
        
        Column {
            anchors.centerIn: parent
            spacing: 12
            
            Text {
                text: "⏳"
                font.pixelSize: 20
                color: dimTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Text {
                text: lang?.ram?.loading_memory || "Loading memory data..."
                color: dimTextColor
                font.pixelSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    function getUsageColor(percent) {
        if (percent > 90) return theme.normal.red
        if (percent > 70) return theme.normal.yellow
        if (percent > 50) return theme.normal.green
        return theme.normal.cyan
    }

}
