import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import Quickshell.Io
import "./Launcher/"

Rectangle {
    id: appIconsRoot
    width: 200
    height: 50
    color: theme.primary.background
    radius: 10
    border.color: theme.button.border
    border.width: 3


    property bool launcherPanelVisible: panelManager.launcher
    property var theme : currentTheme


    Loader {
        id: launcherPanelLoader
        source: "./Launcher/LauncherPanel.qml"
        active: panelManager.launcher
        onLoaded: {
            item.visible = panelManager.launcher
            item.confirmRequested.connect(function(action, actionLabel) {
                confirmDialog.show(action, actionLabel)
            })
            item.lockRequested.connect(function() {
                launcherPanelVisible = false
                // Gọi function showLockscreen từ root (shell.qml)
                if (typeof showLockscreen === "function") {
                    showLockscreen()
                }
            })
        }
    }

    IpcHandler {
        id: ipc
        target: "rect"
        function getToggle() {
            if (launcherPanelLoader.status == Loader.Ready) {
                panelManager.launcher = !panelManager.launcher
                if (panelManager.launcher && launcherPanelLoader.item) {
                    launcherPanelLoader.item.forceActiveFocus()
                    launcherPanelLoader.item.openLauncher()
                }
            } else {
                panelManager.launcher = true
            }
            return 0
        }
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 15

        Repeater {
            model: ["../../assets/launcher/dashboard.png"]

            Image {
                source: modelData
                Layout.preferredWidth: currentSizes.iconSize?.large || 40
                Layout.preferredHeight: currentSizes.iconSize?.large || 40
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        panelManager.launcher = !panelManager.launcher
                        if (launcherPanelLoader.item && panelManager.launcher) {
                            launcherPanelLoader.item.openLauncher()
                        }
                    }
                }
            }
        }
    }
}
