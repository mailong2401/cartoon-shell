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
import qs.modules.bar
import qs.modules.background
import qs.services
import qs.commons

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
    property bool settingsLoaded: false


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
      Bar{
        id: bar
      }
      Connections {
    target: Settings ? Settings : null
    function onSettingsLoaded() {
      root.settingsLoaded = true;
    }
  }
        Loader {
    active: root.settingsLoaded && Directories.ready
    sourceComponent: Item {
      Component.onCompleted: {
        WallpaperService.init();
      }

      Background {}
    }
  }
}
