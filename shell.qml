import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Effects

import qs.config
import qs.components
import qs.modules.dialogs
import qs.modules.panels

ShellRoot {
    id: root

    ThemeLoader { id: themeLoader }
    LanguageLoader { id: languageLoader }
    ConfigLoader { id: configLoader }
    PanelManager { id: panelManager }
    PanelLoaders{ id: panelLoaders}
    VolumeOsd { }
    NotificationPopup{}
    ConfirmDialog { id: confirmDialog }


    // Function để hiển thị confirm dialog từ bất kỳ đâu
    function showConfirmDialog(action, actionLabel) {
        confirmDialog.show(action, actionLabel)
    }



    property var currentTheme: themeLoader.theme
    property var currentLanguage: languageLoader.translations
    property var currentConfig: configLoader.config
    property string currentConfigProfile: configLoader.currentConfigProfile

    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""

    // Property để điều khiển Lockscreen
    property bool lockscreenVisible: false

    // Function để show lockscreen

    // Global wallpaper setter - chạy độc lập với Settings panel
    Process {
        id: globalWallpaperProcess
        command: ["true"]  // dummy command
        running: false

        stdout: StdioCollector {
            onTextChanged: {
                if (text) {
                }
            }
        }

        stderr: StdioCollector {
            onTextChanged: {
                if (text) {
                }
            }
        }

        onRunningChanged: {
        }
    }

    // Function để set wallpaper từ bất kỳ đâu
    function setGlobalWallpaper(filePath) {

        var configPath = Quickshell.env("HOME") + "/.config/quickshell/cartoon-bar"
        var scriptPath = configPath + "/scripts/set-wallpaper.sh"


        // Stop old process if running
        if (globalWallpaperProcess.running) {
            globalWallpaperProcess.running = false
        }

        // Set new command
        globalWallpaperProcess.command = [
            "bash",
            scriptPath,
            filePath
        ]

        // Start process
        globalWallpaperProcess.running = true
    }





PanelWindow {
    visible: panelManager.hasPanel
    color: "transparent"

    implicitWidth: Screen.width
    implicitHeight: Screen.height - 50

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: panelManager.closeAllPanels()
    }
}





    PanelWindow {
        id: panel
        implicitHeight: 50
        color: "transparent"

        anchors {
            left: true
            right: true
            top: currentConfig.mainPanelPos === "top"
            bottom: currentConfig.mainPanelPos === "bottom"
        }

        margins {
            top: currentConfig.mainPanelPos === "top" ? 10 : 0
            left: 10
            right: 10
            bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
        }

        RowLayout {
            anchors.fill: parent

            AppIcons {
                id: appIcons
                Layout.preferredWidth: 60
                Layout.fillHeight: true
            }
            Item{Layout.fillWidth: true}

            WorkspacePanel {
                visible: true
                Layout.preferredWidth: 380
                Layout.fillHeight: true
                hyprInstance: root.hyprInstance
            }
            Item{Layout.fillWidth: true}

            MusicPlayer {
                Layout.preferredWidth: 340
                Layout.fillHeight: true
            }
            Item{Layout.fillWidth: true}

            Timespace {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
            }
            Item{Layout.fillWidth: true}

            CpuPanel {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
            }
            Item{Layout.fillWidth: true}

            StatusArea {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
            }
        }
      }
}
