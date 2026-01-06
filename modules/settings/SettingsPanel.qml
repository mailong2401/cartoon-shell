// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "." as Com
import "../../services" as Services

Rectangle {
    id: settingsPanel
    property var theme : currentTheme
    property var launcherPanel: null  // Reference to LauncherPanel
    signal backRequested()

    radius: 12
    color: theme.primary.background
    // Shadow effect
    layer.enabled: true

    // Shared JsonEditor for all Settings
    Services.JsonEditor {
        id: sharedPanelConfig
        filePath: Qt.resolvedUrl("../../config/configs/" + currentConfigProfile + ".json")
        Component.onCompleted: {
            sharedPanelConfig.load(sharedPanelConfig.filePath)
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 20

        // Sidebar
        Com.SidebarSettings {
            theme: settingsPanel.theme
            onCategoryChanged: function(index) {
                settingsStack.currentIndex = index
            }
            onBackRequested: function() {
                settingsPanel.backRequested()
            }
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
                Com.GeneralSettings {
                    panelConfig: sharedPanelConfig
                }

                // Appearance Settings
                Com.AppearanceSettings {
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
