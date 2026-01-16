import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

import "../../settings" as Settings
import "./" as LauncherComponents

PanelWindow {
    id: launcherPanel

    anchors{
      top: true
      bottom: true
      left: true
      right: true
    }
    color: "transparent"
    focusable: true
    visible: false

    property var theme: currentTheme
    property bool settingsPanelVisible: false
    property bool launcherPanelVisible: true
    property var lang: currentLanguage

    signal confirmRequested(string action, string actionLabel)
    signal lockRequested()

    /* ===============================
       CLICKTHROUGH MASK (QUAN TRỌNG)
       =============================== */

    Region {
      id: launcherMaskRegion
      item: contentRect
    }
    mask: {
      panelManager.launcherMask ? launcherMaskRegion : null
    }


    /* ===============================
       BACKGROUND FULLSCREEN (XUYÊN CLICK)
       =============================== */
        MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: panelManager.closeAllPanels()
    }
        // KHÔNG MouseArea ở đây

    /* ===============================
       CONTENT (KHÔNG XUYÊN CLICK)
       =============================== */
    Rectangle {
        id: contentRect

        anchors {
            left: parent.left
            top: currentConfig.mainPanelPos === "top" ? parent.top : undefined
            bottom: currentConfig.mainPanelPos === "bottom" ? parent.bottom : undefined
        }

        anchors.leftMargin: 10
        anchors.topMargin: currentConfig.mainPanelPos === "top" ? 10 : 0
        anchors.bottomMargin: currentConfig.mainPanelPos === "bottom" ? 10 : 0

        implicitWidth: settingsPanelVisible
            ? (currentSizes.launcherPanel?.settingsWidth || 1000)
            : (currentSizes.launcherPanel?.width || 600)

        implicitHeight: settingsPanelVisible
            ? (currentSizes.launcherPanel?.settingsHeight || 700)
            : (currentSizes.launcherPanel?.height || 640)

        radius: currentSizes.launcherPanel?.radius || 20
        color: theme.primary.background
        border.color: theme.button.border
        border.width: 3
        focus: true

        RowLayout {
            anchors.fill: parent
            anchors.margins: currentSizes.launcherPanel?.margins || 16
            spacing: currentSizes.spacing?.medium || 12

            LauncherComponents.Sidebar {
                id: sidebar
                onAppLaunched: openLauncher()
                onAppSettings: openSettings()
                onConfirmRequested: launcherPanel.confirmRequested
                onLockRequested: launcherPanel.lockRequested
            }

            Settings.SettingsPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: settingsPanelVisible
                launcherPanel: launcherPanel
            }

            ColumnLayout {
                visible: launcherPanelVisible
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    text: lang.system.application
                    color: theme.primary.foreground
                    font.pixelSize: 40
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                    Layout.alignment: Qt.AlignHCenter
                }

                LauncherComponents.LauncherSearch {
                    id: searchBox
                    onSearchChanged: launcherList.runSearch(text)
                    onAccepted: launcherList.runSearch(text)
                }

                LauncherComponents.LauncherList {
                    id: launcherList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onAppLaunched: closePanel()
                }
            }
        }
    }

    /* ===============================
       FUNCTIONS
       =============================== */
    function openSettings() {
        settingsPanelVisible = true
        launcherPanelVisible = false
    }

    function openLauncher() {
        settingsPanelVisible = false
        launcherPanelVisible = true
        Qt.callLater(() => {
            searchBox?.searchField?.forceActiveFocus()
            searchBox?.searchField?.selectAll()
        })
    }

    function closePanel() {
        visible = false
    }

    Shortcut {
        sequence: "Escape"
        onActivated: closePanel()
    }

    onVisibleChanged: {
        if (visible && launcherPanelVisible) {
            Qt.callLater(() => {
                searchBox?.searchField?.forceActiveFocus()
                searchBox?.searchField?.selectAll()
            })
        }
    }
}

