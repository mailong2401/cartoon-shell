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
        spacing: 15

        ColumnLayout {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            spacing: 15

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

            spacing: 15

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
                Com.ListQuickActionButton{}
                
            }
            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 15

                // Left side: Media Player + App Grid + Social Icons
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 15

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15

                        Com.MediaPlayerCard {
                        }

                        Com.AppGridCard {}
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/youtube.png"; bgColor: "#d20f39"; linkSocial: "https://www.youtube.com/"}
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/reddit.png"; bgColor: "#fe640b"; linkSocial: "https://www.reddit.com/"}
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/facebook.png"; bgColor: "#04a5e5"; linkSocial: "https://www.facebook.com/"}
                        Com.SocialIcon { image: "../../../assets/lockscreen/appicons/tiktok.png"; bgColor: "#eff1f5"; linkSocial: "https://www.tiktok.com/"}

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
