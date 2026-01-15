// components/Settings/LockscreenSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "."
import "../../utils/components" as Utils

Item {
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig  // Received from parent SettingsPanel
    id: root

    property int currentIconIndex: -1
    property int currentSocialIconIndex: -1
    property string currentPickerType: ""

    // Reference to launcher panel - will be set from parent
    property var launcherPanel: null

    // File picker process
    Process {
        id: filePickerProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                // Show LauncherPanel again when zenity closes
                if (root.launcherPanel) {
                    root.launcherPanel.visible = true
                }

                if (text && text.length > 0) {
                    const path = text.trim()
                    // Don't save if it's an error message
                    if (path && path.length > 0 && !path.includes("No file picker available")) {
                        switch(root.currentPickerType) {
                            case "avatar":
                                panelConfig.set("lockscreen.avatar", path)
                                break
                            case "background":
                                panelConfig.set("lockscreen.background", path)
                                break
                            case "appIcon":
                                panelConfig.set(`lockscreen.appIcons.${root.currentIconIndex}`, path)
                                break
                            case "socialIcon":
                                panelConfig.set(`lockscreen.socialIcons.${root.currentSocialIconIndex}`, path)
                                break
                        }
                    } else if (path.includes("No file picker available")) {
                        console.error("Please install a file picker: sudo pacman -S zenity")
                    }
                }
            }
        }
    }

    // Helper functions
    function selectAvatar() {
        currentPickerType = "avatar"
        openFilePicker()
    }

    function selectBackground() {
        currentPickerType = "background"
        openFilePicker()
    }

    function selectAppIcon(index) {
        currentIconIndex = index
        currentPickerType = "appIcon"
        openFilePicker()
    }

    function selectSocialIcon(index) {
        currentSocialIconIndex = index
        currentPickerType = "socialIcon"
        openFilePicker()
    }

    function openFilePicker() {
        // Hide LauncherPanel when opening zenity
        if (launcherPanel) {
            launcherPanel.visible = false
        }

        // Use zenity with optimized settings for Hyprland
        filePickerProcess.command = [
            "zenity",
            "--file-selection",
            "--title=Select Image",
            "--file-filter=Image files (png,jpg,jpeg) | *.png *.jpg *.jpeg *.PNG *.JPG *.JPEG",
            "--file-filter=All files | *",
            "--filename=" + (Qt.resolvedUrl("~/Pictures").toString().replace("file://", ""))
        ]
        filePickerProcess.running = true
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: currentSizes.appearanceSettings?.margin || 20
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: currentSizes.appearanceSettings?.sectionSpacing || 20

            // Title
            Text {
                text: lang.lockscreen?.title || "Lock Screen"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: currentSizes.appearanceSettings?.titleFontSize || currentSizes.fontSize?.xlarge || 24
                    bold: true
                }
                Layout.topMargin: currentSizes.spacing?.normal || 10
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }

            // User Information Section
            Text {
                text: lang.lockscreen?.user_info || "User Information"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: currentSizes.fontSize?.large || 20
                    bold: true
                }
                Layout.topMargin: 10
            }

            // Avatar Selection
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text {
                    text: lang.lockscreen?.avatar || "Avatar:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: 150
                }

                Rectangle {
                    width: 80
                    height: 80
                    radius: 40
                    color: theme.button.background
                    border.color: theme.button.border
                    border.width: 2
                    clip: true

                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        source: panelConfig?.get("lockscreen.avatar", "") || ""
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "👤"
                        font.pixelSize: 40
                        visible: !panelConfig?.get("lockscreen.avatar", "")
                    }
                }

                Button {
                    text: lang.lockscreen?.select_avatar || "Select..."
                    onClicked: root.selectAvatar()

                    background: Rectangle {
                        radius: 8
                        color: parent.hovered ? theme.button.background_select : theme.button.background
                        border.color: theme.button.border
                        border.width: 2
                    }

                    contentItem: Text {
                        text: parent.text
                        color: theme.primary.foreground
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // Name Input
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text {
                    text: lang.lockscreen?.name || "Name:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: 150
                }

                TextField {
                    id: nameField
                    text: panelConfig?.get("lockscreen.name", "User") || "User"
                    Layout.preferredWidth: 250
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 14
                    color: theme.primary.foreground

                    onTextChanged: {
                        panelConfig.set("lockscreen.name", text)
                    }

                    background: Rectangle {
                        radius: 8
                        color: theme.primary.background
                        border.color: nameField.focus ? theme.normal.blue : theme.button.border
                        border.width: 2
                    }
                }
            }

            // Username Input
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text {
                    text: lang.lockscreen?.username || "Username:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: 150
                }

                TextField {
                    id: usernameField
                    text: panelConfig?.get("lockscreen.username", "user") || "user"
                    Layout.preferredWidth: 250
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 14
                    color: theme.primary.foreground

                    onTextChanged: {
                    }

                    background: Rectangle {
                        radius: 8
                        color: theme.primary.background
                        border.color: usernameField.focus ? theme.normal.blue : theme.button.border
                        border.width: 2
                    }
                }
            }

            // Background Section
            Text {
                text: lang.lockscreen?.background_section || "Background"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: currentSizes.fontSize?.large || 20
                    bold: true
                }
                Layout.topMargin: 20
            }

            // Background Selection
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Text {
                    text: lang.lockscreen?.background || "Image:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: currentSizes.fontSize?.medium || 16
                    }
                    Layout.preferredWidth: 150
                }

                Rectangle {
                    width: 120
                    height: 80
                    radius: 8
                    color: theme.button.background
                    border.color: theme.button.border
                    border.width: 2

                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        source: panelConfig?.get("lockscreen.background", "") || ""
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "🖼️"
                        font.pixelSize: 40
                        visible: !panelConfig?.get("lockscreen.background", "")
                    }
                }

                Button {
                    text: lang.lockscreen?.select_background || "Select..."
                    onClicked: root.selectBackground()

                    background: Rectangle {
                        radius: 8
                        color: parent.hovered ? theme.button.background_select : theme.button.background
                        border.color: theme.button.border
                        border.width: 2
                    }

                    contentItem: Text {
                        text: parent.text
                        color: theme.primary.foreground
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // App Icons Section (9 icons grid)
            Text {
                text: lang.lockscreen?.app_icons || "App Icons (3x3 Grid)"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: currentSizes.fontSize?.large || 20
                    bold: true
                }
                Layout.topMargin: 20
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 10
                columnSpacing: 10

                Repeater {
                    model: 9

                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: theme.button.background
                        border.color: mouseArea.containsMouse ? theme.normal.blue : theme.button.border
                        border.width: 2

                        Image {
                            anchors.fill: parent
                            anchors.margins: 8
                            source: panelConfig?.get(`lockscreen.appIcons.${index}`, "") || ""
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        Text {
                            anchors.centerIn: parent
                            text: (index + 1).toString()
                            font.pixelSize: 20
                            color: theme.primary.dim_foreground
                            visible: !panelConfig?.get(`lockscreen.appIcons.${index}`, "")
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectAppIcon(index)
                        }
                    }
                }
            }

            // Social Icons Section (4 icons)
            Text {
                text: lang.lockscreen?.social_icons || "Social Icons (1x4)"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: currentSizes.fontSize?.large || 20
                    bold: true
                }
                Layout.topMargin: 20
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: 4

                    Rectangle {
                        width: 60
                        height: 60
                        radius: 12
                        color: theme.button.background
                        border.color: socialMouseArea.containsMouse ? theme.normal.blue : theme.button.border
                        border.width: 2

                        Image {
                            anchors.fill: parent
                            anchors.margins: 8
                            source: panelConfig?.get(`lockscreen.socialIcons.${index}`, "") || ""
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "+"
                            font.pixelSize: 24
                            color: theme.primary.dim_foreground
                            visible: !panelConfig?.get(`lockscreen.socialIcons.${index}`, "")
                        }

                        MouseArea {
                            id: socialMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectSocialIcon(index)
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
