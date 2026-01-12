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

    // Props để nhận data từ parent
    property bool isMuted: false
    property real batteryPercentage: 0
    property bool batteryCharging: false

    // User info props
    property string userName: "Aditya Shakya"
    property string userHandle: "@adi1090x"
    property string userAvatar: "/home/long/Pictures/avatar.jpg"

    // Weather props
    property string weatherCondition: "Clear Sky"
    property string weatherDescription: "It's a clear night\nYou might want to take a evening stroll to relax..."
    property int temperature: 35
    property string weatherIcon: "🌙"

    RowLayout {
        anchors.fill: parent
        spacing: 20

        // ===== COLUMN 1 (Left) - User Profile + Sliders =====
        ColumnLayout {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            spacing: 20

            UserProfileCard {
                userName: dashboardRoot.userName
                userHandle: dashboardRoot.userHandle
                userAvatar: dashboardRoot.userAvatar
            }

            SystemSlider {
                Layout.fillWidth: true
                icon: ""
                iconColor: dashboardRoot.theme.normal.red
                value: 0.8
            }

            SystemSlider {
                Layout.fillWidth: true
                icon: ""
                iconColor: dashboardRoot.theme.normal.blue
                value: 0.5
            }

            SystemSlider {
                Layout.fillWidth: true
                icon: ""
                iconColor: dashboardRoot.theme.normal.yellow
                value: 0.4
            }

            SystemSlider {
                Layout.fillWidth: true
                icon: ""
                iconColor: dashboardRoot.theme.normal.green
                value: dashboardRoot.batteryPercentage
            }
        }


        // ===== COLUMN 2 (Center) - Time, Sleep, Media, Social =====
        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            spacing: 20

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    TimeCard {}
                    SleepTimerCard {}
                }
                WeatherCard {
                    weatherCondition: dashboardRoot.weatherCondition
                    weatherDescription: dashboardRoot.weatherDescription
                    temperature: dashboardRoot.temperature
                    weatherIcon: dashboardRoot.weatherIcon
                }
                ColumnLayout {
                    Layout.preferredWidth: 90
                    spacing: 20

                    RowLayout {

QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: ""
                        iconColor: dashboardRoot.theme.normal.red
                    }

                    QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: ""
                        iconColor: dashboardRoot.theme.normal.yellow
                    }
                    }
                    RowLayout {

QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: ""
                        iconColor: dashboardRoot.theme.normal.red
                    }

                    QuickActionButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        icon: ""
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
                        SocialIcon { icon: ""; bgColor: dashboardRoot.theme.normal.black}
                        SocialIcon { icon: ""; bgColor: dashboardRoot.theme.normal.red }
                        SocialIcon { icon: ""; bgColor: dashboardRoot.theme.normal.blue}
                        SocialIcon { icon: ""; bgColor: dashboardRoot.theme.normal.red}

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
