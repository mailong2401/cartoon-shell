import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    property var theme: currentTheme
    property Process matugenProcess: Process {
        command: ["bash", "-c", ""]
        stdout: StdioCollector {
            onTextChanged: {
                if (text) {
                    console.log("Matugen output:", text)
                }
            }
        }
        stderr: StdioCollector {
            onTextChanged: {
                if (text) {
                    console.log("Matugen error:", text)
                }
            }
        }
        onRunningChanged: {
            if (!running) {
                console.log("Matugen completed for mode:", root.theme.type)
            }
        }
    }

    property Timer reloadTimer: Timer {
        interval: 600
        repeat: false
        onTriggered: themeLoader.loadTheme()
    }

    // Function run matugen by gen image
    function runMatugen(currentWallpaper,themeMode) {
        var command = "matugen image '" + currentWallpaper + "' --mode " + themeMode
        console.log("Running matugen command:", command)
        matugenProcess.command = ["bash", "-c", command]
        matugenProcess.running = true
        
      }

    // Debug to see if triggered working or not;v
    function triggerMatugenOnThemeChange(themeMode) {
        console.log("Theme changed to:", root.theme.type)
        var currentWallpaper = currentConfig.pictureWallpaper || ""
        console.log("Current wallpaper path:", currentWallpaper)
        
        if (currentWallpaper) {
            runMatugen(currentWallpaper,themeMode)
            reloadTimer.restart()
            
        } else {
            console.log("No wallpaper set, skipping matugen")
        }
      }
      function triggerMatugenOnWallpaperChange(currentWallpaper) {
        var command = "matugen image '" + currentWallpaper + "' --mode " + root.theme.type
        console.log("Running matugen command:", command)
        matugenProcess.command = ["bash", "-c", command]
        matugenProcess.running = true
        reloadTimer.restart()
      }
}
