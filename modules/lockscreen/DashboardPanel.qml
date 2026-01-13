import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Services.Mpris
import "components"

Rectangle {
    id: dashboardRoot
    width: 1300
    height: 600
    color: "transparent"

    property var theme: currentTheme



    // Weather props


    RowLayout {
        anchors.fill: parent
        spacing: 20

        // ===== COLUMN 1 (Left) - User Profile + Sliders =====
        ColumnLayout {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            spacing: 20

            UserProfileCard {
            }

            SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/systemslider/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/systemslider/cpu_light.png"
                iconColor: dashboardRoot.theme.normal.red
                value: 0.8
            }

            SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/filebrowser/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/filebrowser/cpu_light.png"
                iconColor: dashboardRoot.theme.normal.blue
                value: 0.5
            }

            SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/filebrowser/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/filebrowser/cpu_light.png"
                iconColor: dashboardRoot.theme.normal.yellow
                value: 0.4
            }

            SystemSlider {
                Layout.fillWidth: true
                iconDark: "../../../assets/lockscreen/filebrowser/cpu_dark.png"
                iconLight: "../../../assets/lockscreen/filebrowser/cpu_light.png"
                iconColor: dashboardRoot.theme.normal.green
                value: 0.3           }
        }


        // ===== COLUMN 2 (Center) - Time, Sleep, Media, Social =====
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
                    TimeCard {}
                    SleepTimerCard {}
                }
                WeatherCard {
                }
                ColumnLayout {
                    Layout.preferredWidth: 90
                    spacing: 20

                    RowLayout {
                        spacing: 15

QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/sys-exit.png"
                        iconColor: dashboardRoot.theme.normal.red
                    }

                    QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/sys-sleep.png"
                        iconColor: dashboardRoot.theme.normal.yellow
                    }
                    }
                    RowLayout {
                        spacing: 15

                    QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/sys-reboot.png"
                        iconColor: dashboardRoot.theme.normal.red
                    }

                    QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: "../../../assets/system/shutdown.png"
                        iconColor: dashboardRoot.theme.normal.yellow
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

                        MediaPlayerCard {
                        }

                        AppGridCard { theme: dashboardRoot.theme }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        SocialIcon { image: "../../../assets/lockscreen/appicons/youtube.png"; bgColor: "#d20f39"}
                        SocialIcon { image: "../../../assets/lockscreen/appicons/reddit.png"; bgColor: "#fe640b" }
                        SocialIcon { image: "../../../assets/lockscreen/appicons/facebook.png"; bgColor: "#04a5e5"}
                        SocialIcon { image: "../../../assets/lockscreen/appicons/tiktok.png"; bgColor: "#eff1f5"}

                        GmailCard {
                            emailCount: 230
                        }
                    }
                }

                // Right side: File Browser
                FileBrowserCard {
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                }
            }
        }

        // ===== COLUMN 3 (Right) - Weather, Apps, Storage, Files, Gmail =====
    }
}
