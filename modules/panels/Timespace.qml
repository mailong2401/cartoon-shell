import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./WeatherTime/" as WeatherTime
import "../../services/" as Service

Rectangle {
    id: root
    color: theme.primary.background
    radius: 10
    border.color: theme.button.border
    border.width: 3


    property var lang: currentLanguage
    property bool panelVisible: false
    property bool flagPanelVisible: false
    property bool weatherPanelVisible: false
    property string selectedFlag: currentConfig.countryFlag
    property var theme : currentTheme

    Service.WeatherService{
      id: weatherService
    }
    Service.DateTimeService{
      id: dateTimeService
    }

    RowLayout {
            anchors.fill: parent
    anchors {
        leftMargin: 10
        rightMargin: 10
        topMargin: 5
        bottomMargin: 5
    }
    spacing: 5


        // Phần datetime - căn trái
        Item {
            id: timeContainer
            Layout.preferredWidth: textCurrentDate.implicitWidth + 20
            Layout.fillHeight: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 0
                Text {
                    text: dateTimeService.currentTime
                    color: root.theme.primary.foreground
                    font {
                        pixelSize: 16
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                }

                Text {
                    id: textCurrentDate
                    text: dateTimeService.currentDate
                    color: root.theme.primary.dim_foreground
                    font.pixelSize: 13
                    font.family: "ComicShannsMono Nerd Font"
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("calendar")
                }
                
                // Hiệu ứng hover
                onEntered: {
                    timeContainer.scale = 1.04
                }
                onExited: {
                    timeContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Spacer để đẩy phần giữa ra chính giữa
        Item {
            Layout.fillWidth: true
        }

        // Phần weather - căn giữa
        Item {
            id: weatherContainer
            Layout.preferredWidth: contentWeather.implicitWidth
            Layout.fillHeight: true

            RowLayout {
                id: contentWeather
                anchors.centerIn: parent
                Image {
                    source: weatherService.icon
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false
                    smooth: true
                    mipmap: true
                }

                ColumnLayout {
                    spacing: 1
                    Text {
                        text: weatherService.temperature || "Đang tải..."
                        color: root.theme.primary.foreground
                        Layout.alignment: Qt.AlignVCenter
                        font {
                            pixelSize: 16
                            bold: true
                            family: "ComicShannsMono Nerd Font"
                        }
                    }
                    
                    Text {
                        id: textCondition
                        text: weatherService.condition || "..."
                        color: root.theme.primary.dim_foreground
                        font {
                            pixelSize: 11
                            family: "ComicShannsMono Nerd Font"
                        }
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }
                }
                
                
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("weather")
                }
                
                onEntered: {
                    weatherContainer.scale = 1.04
                }
                onExited: {
                    weatherContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Spacer để đẩy phần flag sang bên phải
        Item {
            Layout.fillWidth: true
        }

        // Flag Selector - căn phải
        Item {
            id: flagContainer
            Layout.preferredWidth: 50
            Layout.fillHeight: parent

            Image {
                source: root.selectedFlag ? `../../assets/flags/${root.selectedFlag}.png` : ""
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.centerIn: parent
                visible: root.selectedFlag !== ""
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("flag")
                }

                onEntered: {
                    flagContainer.scale = 1.1
                }
                onExited: {
                    flagContainer.scale = 1.0
                }
            }

            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }
}
