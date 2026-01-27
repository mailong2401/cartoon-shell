import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components
import "./appearance/" as Com
import "." as BarList

Item {
    id: rootAppearance
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig
    property int currentTab: 0

    ListSettingsService {
        id: listSettingService
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // BarListSettings - chỉ hiển thị khi fullsetting
        BarList.BarListSettings {
            currentIndex: rootAppearance.currentTab
            onCategoryChanged: function(index) {
                rootAppearance.currentTab = index
            }
            title: listSettingService.listCategories[1]?.categoryName || "Appearance"
            listModal: listSettingService.listCategories[1]?.items || []
            visible: panelManager.fullsetting
            Layout.preferredWidth: 260
            Layout.fillHeight: true
        }

        // Main Content Area

            
            ColumnLayout {
                width: parent.width
                spacing: 20
                anchors.margins: 20

                // StackLayout for tabs
                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: rootAppearance.currentTab

                    // Tab 0: Theme
                    Com.Theme {
                        panelConfig: rootAppearance.panelConfig
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    // Tab 1: Panel
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        RowLayout {
                            Layout.fillWidth: true
                            
                            Text {
                                text: lang?.appearance?.panel || "Panel"
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 24
                                    bold: true
                                }
                            }
                            
                            Item {
                                Layout.fillWidth: true
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: theme.primary.foreground
                            opacity: 0.3
                        }

                        // Panel settings content
                        Text {
                            text: "Panel settings content"
                            color: theme.primary.foreground
                        }
                    }

                    // Tab 2: Clock
                    Com.ClockTime {
                        panelConfig: rootAppearance.panelConfig
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    // Tab 3: Fonts
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Text {
                            text: lang?.appearance?.fonts || "Fonts"
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

                        // Fonts settings content
                        Text {
                            text: "Fonts settings content"
                            color: theme.primary.foreground
                        }
                    }

                    // Tab 4: Icons
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Text {
                            text: lang?.appearance?.icons || "Icons"
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

                        // Icons settings content
                        Text {
                            text: "Icons settings content"
                            color: theme.primary.foreground
                        }
                    }

                    // Tab 5: Effects
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Text {
                            text: lang?.appearance?.effects || "Effects"
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

                        // Effects settings content
                        Text {
                            text: "Effects settings content"
                            color: theme.primary.foreground
                        }
                    }

                    // Tab 6: Layout
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Text {
                            text: lang?.appearance?.layout || "Layout"
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

                        // Layout settings content
                        Text {
                            text: "Layout settings content"
                            color: theme.primary.foreground
                        }
                    }

                    // Tab 7: Wallpaper
                    Com.Wallpapers {
                        panelConfig: rootAppearance.panelConfig
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    // Tab 8: Advanced (nếu cần)
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Text {
                            text: "Advanced"
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

                        // Advanced settings content
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
