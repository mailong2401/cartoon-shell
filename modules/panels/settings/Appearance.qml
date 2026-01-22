import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import "./appearance/" as Com

Item {
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig  // Received from parent SettingsPanel
    id: root
    
    // Hàm helper để set position
    function setClockPosition(position) {
        panelConfig.set("clockPanelPosition", position)
    }

    property int currentTab: 0
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar chọn tab
        Com.SideBar{
          currentTab: root.currentTab
        }
        

        // Nội dung các tab
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentTab

            // Tab Theme
            Com.Theme{
              panelConfig: root.panelConfig
              Layout.fillWidth: true

            }
            

            // Tab Panel
            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Text {
                        text: lang.appearance?.panel || "Panel"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }

                    // Nội dung Panel ở đây
                    Text {
                        text: "Panel settings content"
                        color: theme.primary.foreground
                    }
                }
            }

            // Tab Clock
            Com.ClockTime{
              panelConfig: root.panelConfig
              Layout.fillWidth: true


            }

            // Tab Fonts
            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Text {
                        text: lang.appearance?.fonts || "Fonts"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }

                    // Nội dung Fonts ở đây
                    Text {
                        text: "Fonts settings content"
                        color: theme.primary.foreground
                    }
                }
            }

            // Tab Icons
            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Text {
                        text: lang.appearance?.icons || "Icons"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }

                    // Nội dung Icons ở đây
                    Text {
                        text: "Icons settings content"
                        color: theme.primary.foreground
                    }
                }
            }

            // Tab Effects
            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Text {
                        text: lang.appearance?.effects || "Effects"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }

                    // Nội dung Effects ở đây
                    Text {
                        text: "Effects settings content"
                        color: theme.primary.foreground
                    }
                }
            }

            // Tab Layout
            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Text {
                        text: lang.appearance?.layout || "Layout"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }

                    // Nội dung Layout ở đây
                    Text {
                        text: "Layout settings content"
                        color: theme.primary.foreground
                    }
                }
            }

            // Tab Wallpaper
            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Text {
                        text: lang.appearance?.wallpaper || "Wallpaper"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }

                    // Nội dung Wallpaper ở đây
                    Text {
                        text: "Wallpaper settings content"
                        color: theme.primary.foreground
                    }
                }
            }

            // Tab Advanced
            ScrollView {
                clip: true
                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Text {
                        text: lang.appearance?.advanced || "Advanced"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }

                    // Nội dung Advanced ở đây
                    Text {
                        text: "Advanced settings content"
                        color: theme.primary.foreground
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("AppearanceSettings loaded")
    }
}
