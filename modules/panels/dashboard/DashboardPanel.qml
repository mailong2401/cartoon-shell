import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Com

PanelWindow {
  id: root
  implicitWidth:  1300
  implicitHeight: 600

  property var theme: currentTheme

  color: "transparent"
  Rectangle {
      anchors.fill: parent
      color: "transparent"

      RowLayout {
        anchors.fill: parent
        spacing: 20

        ColumnLayout {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            spacing: 20

            Com.UserProfileCard {
            }

            Com.SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/systemslider/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/systemslider/cpu_light.png"
                iconColor: theme.normal.red
                value: 0.8
            }

            Com.SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/filebrowser/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/filebrowser/cpu_light.png"
                iconColor: theme.normal.blue
                value: 0.5
            }

            Com.SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/filebrowser/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/filebrowser/cpu_light.png"
                iconColor: theme.normal.yellow
                value: 0.4
            }

            Com.SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/filebrowser/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/filebrowser/cpu_light.png"
                iconColor: theme.normal.green
                value: 0.3           }
        }

          ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: 20

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing:15
                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Com.TimeCard {}
                    Com.SleepTimerCard {}
                }
                Com.WeatherCard {
                }
                ColumnLayout {
                    Layout.preferredWidth: 90
                    spacing: 20

                    RowLayout {
                        spacing: 15

                    Com.QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/sys-exit.png"
                        iconColor: theme.normal.red
                    }

                    Com.QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/sys-sleep.png"
                        iconColor: theme.normal.yellow
                    }
                    }
                    RowLayout {
                        spacing: 15

                    Com.QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/sys-reboot.png"
                        iconColor: theme.normal.red
                    }

                    Com.QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/shutdown.png"
                        iconColor: theme.normal.yellow
                    }
                    }

                    
                }
            }
            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 10

                // Left side: Media Player + App Grid + Social Icons
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Com.MediaPlayerCard {
                        }

                        Com.AppGridCard { theme: dashboardRoot.theme }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/youtube.png"; bgColor: "#d20f39"}
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/reddit.png"; bgColor: "#fe640b" }
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/facebook.png"; bgColor: "#04a5e5"}
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/tiktok.png"; bgColor: "#eff1f5"}

                        Com.GmailCard {
                            emailCount: 230
                        }
                    }
                }

                // Right side: File Browser
                Com.FileBrowserCard {
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                }
            }
        }

}

  }

}
