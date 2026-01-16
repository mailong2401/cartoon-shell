import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

// Import các thành phần phụ trong cùng thư mục
import "../../settings" as Settings
import "./" as LauncherComponents

PanelWindow {
    id: launcherPanel
    
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"  // Đổi từ "red" sang "transparent"
    focusable: true

    signal closeRequested()
    signal confirmRequested(string action, string actionLabel)
    signal lockRequested()

    Behavior on width { NumberAnimation { duration: 10 } }
    Behavior on height { NumberAnimation { duration: 10 } }

    property var theme: currentTheme
    property bool settingsPanelVisible: false
    property var lang : currentLanguage
    property bool launcherPanelVisible: true


    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.exclusiveZone: -1

    // Xóa MouseArea cũ và thay bằng PointHandler
    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: closeRequested()
    }

    function openSettings() {
        launcherPanel.settingsPanelVisible = true
        launcherPanel.launcherPanelVisible = false
    }

    function openLauncher() {
        launcherPanel.settingsPanelVisible = false
        launcherPanel.launcherPanelVisible = true
        // Focus vào search field khi mở launcher
        Qt.callLater(function() {
            if (searchBox && searchBox.searchField) {
                searchBox.searchField.forceActiveFocus()
                searchBox.searchField.selectAll()
            }
        })
    }

    function closePanel() {
        visible = false
        closeRequested()
    }

    function togglePanel() {
        launcherPanel.visible = !launcherPanel.visible
        if (launcherPanel.visible) {
            openLauncher()
        }
    }

    // Rectangle chính chứa nội dung
    Rectangle {
        id: contentRect
        anchors {
            top: currentConfig.mainPanelPos === "top" ? parent.top : undefined
            bottom: currentConfig.mainPanelPos === "bottom" ? parent.bottom : undefined
            left: parent.left
        }
        anchors.topMargin: currentConfig.mainPanelPos === "top" ? currentSizes.panelHeight + 10 : 0
        anchors.bottomMargin: currentConfig.mainPanelPos === "bottom" ? currentSizes.panelHeight + 10 : 0
        anchors.leftMargin: 10
        
        implicitWidth: launcherPanel.settingsPanelVisible ? 
            (currentSizes.launcherPanel?.settingsWidth || 1000) : 
            (currentSizes.launcherPanel?.width || 600)
        implicitHeight: launcherPanel.settingsPanelVisible ? 
            (currentSizes.launcherPanel?.settingsHeight || 700) : 
            (currentSizes.launcherPanel?.height || 640)
        
        radius: currentSizes.launcherPanel?.radius || 20
        color: theme.primary.background
        border.color: theme.button.border
        border.width: 3
        focus: true  // Đảm bảo có thể nhận focus
        
        // Ngăn sự kiện click bên trong lan ra ngoài
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
            onClicked: {
                // Không làm gì cả, chỉ để ngăn click lan ra ngoài
                mouse.accepted = true
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: currentSizes.launcherPanel?.margins || 16
            spacing: currentSizes.spacing?.medium || 12

            LauncherComponents.Sidebar {
                id: sidebar
                onAppLaunched: launcherPanel.openLauncher()
                onAppSettings: launcherPanel.openSettings()
                onConfirmRequested: (action, actionLabel) => {
                    launcherPanel.confirmRequested(action, actionLabel)
                }
                onLockRequested: {
                    launcherPanel.lockRequested()
                }
            }

            Settings.SettingsPanel {
                id: settingsPanel
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: launcherPanel.settingsPanelVisible
                launcherPanel: launcherPanel
                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
                }
            }

            ColumnLayout {
                visible: launcherPanel.launcherPanelVisible
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: currentSizes.launcherPanel?.spacing || 10

                Text {
                    text: lang.system.application
                    color: theme.primary.foreground
                    font.pixelSize: currentSizes.launcherPanel?.titleFontSize ||  40
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                    Layout.alignment: Qt.AlignHCenter
                }

                LauncherComponents.LauncherSearch {
                    id: searchBox
                    onSearchChanged: (text) => launcherList.runSearch(text)
                    onAccepted: (text) => launcherList.runSearch(text)
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

    // Khi panel trở nên visible, focus vào search field
    onVisibleChanged: {
        if (visible && launcherPanelVisible) {
            Qt.callLater(function() {
                if (searchBox && searchBox.searchField) {
                    searchBox.searchField.forceActiveFocus()
                    searchBox.searchField.selectAll()
                }
            })
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: closePanel()
    }

    Component.onCompleted: {
        // Đảm bảo panel không visible khi khởi động
        visible = false
    }
}
