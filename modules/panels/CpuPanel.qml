import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import './widgets/'
import '../modules/ram/'
import '../../services/' as Service

Rectangle {
    id: root
    color: theme.primary.background
    border.color: theme.button.border
    border.width: 3
    radius: 10
    clip: true

    property string memoryUsage: "0%"
    property var theme : currentTheme
    Service.CpuService{
      id: cpuService
      enableCpuHistory: true
    }
    Service.RamService{
      id: ramService
      useSimpleCalculation: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 4

        // CPU Container - Click để mở panel chi tiết
        Rectangle {
            id: cpuContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            radius: 6

            RowLayout {
                id: cpuContent
                anchors.centerIn: parent
                spacing: 2

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0
                    Text {
                        id: cpuText
                        text: cpuService.cpuPercent + "%"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 15
                            bold: true
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        id: cpuLabel
                        text: "Cpu"
                        color: theme.primary.dim_foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 10
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                Image {
                    id: cpuIcon
                    source: "../../assets/cpu/cpu.png"
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                  panelManager.togglePanel("cpu")
                }

                // Hiệu ứng hover - dùng opacity thay vì scale để tránh tràn
                onEntered: {
                    cpuContainer.opacity = 0.8
                }
                onExited: {
                    cpuContainer.opacity = 1.0
                }
            }

            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        // Memory Container
        Rectangle {
            id: memoryContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            radius: 6

            RowLayout {
                id: memoryContent
                anchors.centerIn: parent
                spacing: 2

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0
                    Text {
                        id: memoryText
                        text: ramService.memPercent + "%"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 15
                            bold: true
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        id: memoryLabel
                        text: "Ram"
                        color: theme.primary.dim_foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 10
                        }
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                Image {
                    id: memoryIcon
                    source: "../../assets/panel/memory.png"
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  panelManager.togglePanel("ram")
                }

                // Hiệu ứng hover - dùng opacity thay vì scale để tránh tràn
                onEntered: {
                    memoryContainer.opacity = 0.8
                }
                onExited: {
                    memoryContainer.opacity = 1.0
                }
            }

            Behavior on opacity { NumberAnimation { duration: 100 } }
        }
    }

}
