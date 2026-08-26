import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "." as Com
import qs.services
import qs.services.cpu

PanelWindow {
    id: root
    implicitWidth: ScalerService.s(1300)
    implicitHeight: ScalerService.s(600)

    property real animationProgress: 0
    PackageService {
        id: packageService
        simplePackage: true
    }
    SequentialAnimation on animationProgress {
        running: true

        NumberAnimation {
            from: 0
            to: 2
            duration: 2000
            easing.type: Easing.Linear
        }
    }

    RamService {
        id: ramService
        useSimpleCalculation: true
    }

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        RowLayout {
            anchors.fill: parent
            spacing: ScalerService.s(15)

            // Left Column - Staggered animation
            ColumnLayout {
                Layout.preferredWidth: ScalerService.s(240)
                Layout.fillHeight: true
                spacing: ScalerService.s(15)

                Com.UserProfileCard {
                    animationProgress: root.animationProgress
                }

                Com.SystemSlider {
                    Layout.fillWidth: true
                    nameIcon: "memory"
                    iconColor: theme.normal.red
                    value: CpuSimpleService.cpuPercent / 100
                    revealThreshold: 0.25
                    animationProgress: root.animationProgress
                }

                Com.SystemSlider {
                    Layout.fillWidth: true
                    nameIcon: "memory_alt"
                    iconColor: theme.normal.green
                    value: ramService.memPercent / 100
                    revealThreshold: 0.3
                    animationProgress: root.animationProgress
                }

                Com.SystemSlider {
                    Layout.fillWidth: true
                    nameIcon: "hard_disk"
                    iconColor: theme.normal.blue
                    value: DiskService.diskPercents / 100
                    revealThreshold: 0.35
                    animationProgress: root.animationProgress
                }
            }

            // Right Main Column
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: ScalerService.s(15)

                // Top Row
                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: ScalerService.s(15)

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.preferredWidth: ScalerService.s(100)

                        Com.TimeCard {
                            animationProgress: root.animationProgress
                        }

                        Com.SleepTimerCard {
                            animationProgress: root.animationProgress
                        }
                    }

                    Com.WeatherCard {
                        animationProgress: root.animationProgress
                    }

                    Com.ListQuickActionButton {
                        animationProgress: root.animationProgress
                    }
                }

                // Bottom Row
                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: ScalerService.s(15)

                    // Left side: Media Player + App Grid + Social Icons
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: ScalerService.s(15)

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: ScalerService.s(15)

                            Com.MediaPlayerCard {
                                animationProgress: root.animationProgress
                            }

                            Com.AppGridCard {
                                animationProgress: root.animationProgress
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: ScalerService.s(15)

                            Com.SocialIcon {
                                image: "lockscreen/appicons/youtube.png"
                                bgColor: root.animationProgress > 0.55 ? "#d20f39" : theme.primary.background
                                revealThreshold: 0.6
                                linkSocial: "https://www.youtube.com/"
                                opacity: root.animationProgress > 0.4 ? 1 : 0
                                animationProgress: root.animationProgress
                            }
                            Com.SocialIcon {
                                image: "lockscreen/appicons/reddit.png"
                                bgColor: root.animationProgress > 0.6 ? "#fe640b" : theme.primary.background
                                revealThreshold: 0.65
                                linkSocial: "https://www.reddit.com/"
                                opacity: root.animationProgress > 0.45 ? 1 : 0
                                animationProgress: root.animationProgress
                            }
                            Com.SocialIcon {
                                image: "lockscreen/appicons/facebook.png"
                                bgColor: root.animationProgress > 0.65 ? "#04a5e5" : theme.primary.background
                                revealThreshold: 0.7
                                linkSocial: "https://www.facebook.com/"
                                opacity: root.animationProgress > 0.5 ? 1 : 0
                                animationProgress: root.animationProgress
                            }
                            Com.SocialIcon {
                                image: "lockscreen/appicons/tiktok.png"
                                bgColor: root.animationProgress > 0.65 ? "#eff1f5" : theme.primary.background
                                revealThreshold: 0.75
                                linkSocial: "https://www.tiktok.com/"
                                opacity: root.animationProgress > 0.55 ? 1 : 0
                                animationProgress: root.animationProgress
                            }

                            Com.PackageCard {
                                count: packageService.totalPackage
                                animationProgress: root.animationProgress
                            }
                        }
                    }

                    // Right side: File Browser
                    Com.FileBrowserCard {
                        Layout.preferredWidth: ScalerService.s(300)
                        Layout.fillHeight: true
                        animationProgress: root.animationProgress
                    }
                }
            }
        }
    }
}
