import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Effects

import "./config" as Config
import "./modules/dialogs" as Dialogs
import "./modules/panels" as Panels
import "./modules/lockscreen" as Lockscreen
import "./components/" as Components

ShellRoot {
    id: root

    Config.ThemeLoader { id: themeLoader }
    Config.LanguageLoader { id: languageLoader }
    Config.ConfigLoader { id: configLoader }
    Config.PanelManager { id: panelManager }
    Components.PanelLoaders{ id: panelLoaders}
    Dialogs.VolumeOsd { }
    Dialogs.NotificationPopup{}
    Dialogs.ConfirmDialog { id: confirmDialog }

    // Lockscreen context
    Lockscreen.LockContext {
		id: lockContext

		onUnlocked: {
			// Unlock the screen before exiting, or the compositor will display a
			// fallback lock you can't interact with.
        lockscreenVisible = false;

		}
	}
    WlSessionLock {
		id: lock

		// Lock the session immediately when quickshell starts.
		locked: lockscreenVisible

		WlSessionLockSurface {
			Lockscreen.LockSurface {
				anchors.fill: parent
				context: lockContext
			}
		}
	}

    // Function để hiển thị confirm dialog từ bất kỳ đâu
    function showConfirmDialog(action, actionLabel) {
        confirmDialog.show(action, actionLabel)
    }

    property bool clockPanelVisible: currentConfig.clockPanelVisible


    property bool anchorsTop: currentConfig.clockPanelPosition === "top" || currentConfig.clockPanelPosition === "topLeft" || currentConfig.clockPanelPosition === "topRight"
    property bool anchorsBottom: currentConfig.clockPanelPosition === "bottom" || currentConfig.clockPanelPosition === "bottomLeft" || currentConfig.clockPanelPosition === "bottomRight"
    property bool anchorsRight: currentConfig.clockPanelPosition === "right" || currentConfig.clockPanelPosition === "topRight" || currentConfig.clockPanelPosition === "bottomRight"
    property bool anchorsLeft: currentConfig.clockPanelPosition === "left" || currentConfig.clockPanelPosition === "topLeft" || currentConfig.clockPanelPosition === "bottomLeft"

    Panels.ClockPanel {
        id: clockPanel
        visible: clockPanelVisible
        anchors {
        top: anchorsTop
        bottom: anchorsBottom
        left: anchorsLeft
        right: anchorsRight
    }
    }


    function toggleClockPanel() {
        clockPanelVisible = !clockPanelVisible
    }

    property var currentTheme: themeLoader.theme
    property var currentLanguage: languageLoader.translations
    property var currentConfig: configLoader.config
    property string currentConfigProfile: configLoader.currentConfigProfile


        function openPanel(panelName) {
        panelManager.openPanel(panelName)
    }

    // Function để toggle một panel
    function togglePanel(panelName) {
        panelManager.togglePanel(panelName)
    }

    // Function để đóng tất cả panel
    function closeAllPanels() {
        panelManager.closeAllPanels()
    }




    property string hyprInstance: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || ""

    // Property để điều khiển Lockscreen
    property bool lockscreenVisible: false

    // Function để show lockscreen
    function showLockscreen() {
        lockscreenVisible = true
    }

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

    Connections {
        target: languageLoader
        function onLanguageChanged() {
            currentLanguage = languageLoader.translations
        }
    }

    Connections {
        target: themeLoader
        function onThemeReloaded() {
            currentTheme = themeLoader.theme
        }
    }

    Connections {
        target: configLoader
        function onConfigReloaded() {
            currentConfig = configLoader.config
        }
    }



      PanelWindow{
        visible: panelManager.hasPanel
        color: "transparent"
        anchors: {
          right: true
          left : true
          top: currentConfig.mainPanelPos === "top"
          bottom: currentConfig.mainPanelPos === "bottom"
        }
        width: Screen.width
        height: Screen.height - 50
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
            spacing: currentConfig.spacingPanel

            Panels.AppIcons {
                id: appIcons
                Layout.preferredWidth: 60
                Layout.fillHeight: true
            }

            Panels.WorkspacePanel {
                Layout.preferredWidth: 380
                Layout.fillHeight: true
                hyprInstance: root.hyprInstance
            }

            Panels.MusicPlayer {
                Layout.preferredWidth: 340
                Layout.fillHeight: true
            }

            Panels.Timespace {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
            }

            Panels.CpuPanel {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
            }

            Panels.StatusArea {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
            }
        }
      }
      

    // Lockscreen overlay
    
}
