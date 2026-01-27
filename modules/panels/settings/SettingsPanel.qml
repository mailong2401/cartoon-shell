// components/Settings/SettingsPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "." as Com
import qs.services

Rectangle {
    id: rootSettings
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
        Com.Sidebar {
            theme: rootSettings.theme
            onCategoryChanged: function(index) {
                rootSettings.currentTab = 0
                settingsStack.currentIndex = index
            }
            onBackRequested: function() {
                rootSettings.backRequested()
            }
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
                Loader {
                    id: settingsGeneral
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    active: settingsStack.currentIndex === 0
                    source: "./General.qml"
                    onLoaded: {
                        item.visible = Qt.binding(function() { return settingsStack.currentIndex === 0 })
                        item.currentTab = rootSettings.currentTab
                        item.panelConfig = sharedPanelConfig
                    }
                  }
                  Loader {
                    id: settingsAppearance
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    active: settingsStack.currentIndex === 1
                    source: "./Appearance.qml"
                    onLoaded: {
                        item.visible = Qt.binding(function() { return settingsStack.currentIndex === 1 })
                        item.currentTab = rootSettings.currentTab
                        item.panelConfig = sharedPanelConfig
                    }
                }


                // Lockscreen Settings
                Com.Dashboard {
                    panelConfig: sharedPanelConfig
                    launcherPanel: rootSettings.launcherPanel
                }

                // Network Settings
                Com.Network {
                }
                
                // Audio Settings
                Com.Audio {
                }
                
                // Performance Settings
                Com.Performance {
                }
                
                // Shortcuts Settings
                Com.Shortcuts {
                }
                
                // System Settings
                Com.System {
                }
            }
        }
    }
}
