// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "." as Com
import qs.services

Rectangle {
    id: settingsPanel
    property var theme : currentTheme
    property var lang: currentLanguage
    property var launcherPanel: null  // Reference to LauncherPanel
    property int currentTab: 0
    signal backRequested()

    radius: 12
    color: theme.primary.background

    // Shadow effect
    layer.enabled: true

    // Shared JsonEditor for all Settings
    JsonEditor {
        id: sharedPanelConfig
        filePath: Qt.resolvedUrl("../../../config/configs/" + currentConfigProfile + ".json")
        Component.onCompleted: {
            sharedPanelConfig.load(sharedPanelConfig.filePath)
        }
    }
    
    ListSettingsService {
        id: listSettingService
    }

    RowLayout {
        anchors.fill: parent
        spacing: 20

        // Sidebar - chỉ hiển thị khi không ở chế độ fullsetting
        Com.SidebarSettings {
            theme: settingsPanel.theme
            onCategoryChanged: function(index) {
                settingsPanel.currentTab = 0
                settingsStack.currentIndex = index
            }
            onBackRequested: function() {
                settingsPanel.backRequested()
            }
            Layout.fillHeight: true
        }

        // BarListSettings - chỉ hiển thị khi ở chế độ fullsetting
        Com.BarListSettings {
            currentIndex: settingsPanel.currentTab
            onCategoryChanged: function(index) {
                settingsPanel.currentTab = index
            }
            title: listSettingService.listCategories[settingsStack.currentIndex].categoryName
            listModal: listSettingService.listCategories[settingsStack.currentIndex].items
            visible: panelManager.fullsetting
            Layout.preferredWidth: 260
            Layout.fillHeight: true
        }
        
        // Content Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: theme.primary.dim_background
            radius: 8
            border {
                color: theme.button.border
                width: 2
            }
            
            StackLayout {
                id: settingsStack
                anchors.fill: parent
                anchors.margins: 8
                currentIndex: 0
                
                // General Settings
                Com.General {
                    currentTab: settingsPanel.currentTab
                    panelConfig: sharedPanelConfig
                }

                // Appearance Settings
                Com.Appearance {
                    currentTab: settingsPanel.currentTab
                    panelConfig: sharedPanelConfig
                }

                // Wallpapers Settings
                Com.WallpapersSettings {
                    panelConfig: sharedPanelConfig
                }

                // Lockscreen Settings
                Com.DashboardSettings {
                    panelConfig: sharedPanelConfig
                    launcherPanel: settingsPanel.launcherPanel
                }

                // Network Settings
                Com.NetworkSettings {
                }
                
                // Audio Settings
                Com.AudioSettings {
                }
                
                // Performance Settings
                Com.PerformanceSettings {
                }
                
                // Shortcuts Settings
                Com.ShortcutsSettings {
                }
                
                // System Settings
                Com.SystemSettings {
                }
            }
        }
    }
}
