import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "."

Item {
    id: root
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig  // Received from parent SettingsPanel

    property int currentIconIndex: -1
    property int currentSocialIconIndex: -1
    property string currentPickerType: ""
    property var apps: []

    // Reference to launcher panel - will be set from parent
    property var launcherPanel: null
    Timer {
      id: delayTimer
      interval: 60 // milliseconds
      repeat: false
      property var callback: null
    
      onTriggered: {
        callback()
      }
    }

    function runlistapp() {
        if (!listAppsProccess.running) {
            listAppsProccess.running = true
        }
    }

    Process {
        id: listAppsProccess
        command: Qt.resolvedUrl("../../scripts/listappsdashboard.py")
        running: false
        stdout: StdioCollector { 
            id: outputCollector 
            onTextChanged: {
                try {
                    var txt = text ? text.trim() : ""
                    if (txt !== "") {
                        root.apps = JSON.parse(txt)
                        console.log("Loaded apps:", root.apps.length)
                    } else {
                        root.apps = []
                    }
                } catch(e) {
                    console.error("Error parsing JSON:", e)
                    root.apps = []
                }
            }
        }

        onExited: {
            running = false
        }
    }

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
        
        if (gridAppIcons.visible) {
            gridAppIcons.visible = false
        } else {
            // Load apps if not loaded yet
            if (apps.length === 0) {
                runlistapp()
            }
            gridAppIcons.visible = true
        }
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

    // Grid App Icons Selector
    Rectangle {
        id: gridAppIcons
        visible: false
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        width: 400
        height: 400
        radius: 12
        color: theme.primary.background
        border.color: theme.normal.blue
        border.width: 2
        z: 1001
        
        // Close button
        Rectangle {
            id: closeButton
            width: 30
            height: 30
            radius: 15
            color: theme.normal.red
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            
            Text {
                anchors.centerIn: parent
                text: "✕"
                color: theme.primary.foreground
                font.pixelSize: 16
                font.bold: true
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: gridAppIcons.visible = false
            }
        }
        
        // Title
        Text {
            id: gridTitle
            text:  "Select Application Icon"
            color: theme.primary.foreground
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 15
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: 16
                bold: true
            }
        }
        
        // Search field
        TextField {
            id: searchField
            anchors.top: gridTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            anchors.topMargin: 10
            placeholderText: lang.lockscreen?.search_apps || "Search applications..."
            font.family: "ComicShannsMono Nerd Font"
            font.pixelSize: 14
            color: theme.primary.foreground
            
            onTextChanged: {
                appGrid.model = filterApps()
            }
            
            background: Rectangle {
                radius: 8
                color: theme.button.background
                border.color: searchField.focus ? theme.normal.blue : theme.button.border
                border.width: 2
            }
        }
        
        // App grid view
        ScrollView {
            id: scrollView
            anchors.top: searchField.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 15
            anchors.topMargin: 10
            clip: true
            
            Grid {
                id: appGrid
                width: scrollView.availableWidth
                spacing: 10
                columns: Math.floor(scrollView.availableWidth / 80)
                
                Repeater {
                    id: appRepeater
                    model: root.apps
                    
                    Rectangle {
                        width: 80
                        height: 80
                        radius: 8
                        color: mouseArea.containsMouse ? theme.normal.blue : theme.button.background
                        border.color: theme.button.border
                        border.width: 1
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 5
                            
                            // App icon
                            Rectangle {
                                width: 50
                                height: 60
                                radius: 8
                                color: "transparent"
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    source: modelData.iconPath || ""
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    Rectangle {
                                        anchors.fill: parent
                                        color: theme.button.background
                                        visible: !modelData.iconPath || parent.status === Image.Error
                                        Text {
                                            anchors.centerIn: parent
                                            text: "📱"
                                            font.pixelSize: 20
                                            color: theme.primary.dim_foreground
                                        }
                                    }
                                }
                                
                              }
                              Text {
                                width: 65
                                text: getAppName(modelData.exec)
                                color: theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 10
                                }
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                maximumLineCount: 2
                                wrapMode: Text.WordWrap
                            }

                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.iconPath) {
                                    panelConfig.set(`dashboard.listApp.${root.currentIconIndex}.pathIcon`, modelData.iconPath)
                                    delayTimer.callback = function() {
                                        panelConfig.set(`dashboard.listApp.${root.currentIconIndex}.exec`, modelData.exec)
                                    }
                                    delayTimer.start()
                                    
                                    gridAppIcons.visible = false
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Loading indicator
        Rectangle {
            id: loadingIndicator
            anchors.centerIn: parent
            width: 100
            height: 100
            radius: 10
            color: theme.primary.background
            border.color: theme.button.border
            border.width: 2
            visible: listAppsProccess.running
            
            Column {
                anchors.centerIn: parent
                spacing: 10
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "⏳"
                    font.pixelSize: 30
                    color: theme.primary.foreground
                }
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: lang.lockscreen?.loading || "Loading..."
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 12
                    }
                }
            }
        }
        
        // Empty state
        Rectangle {
            id: emptyState
            anchors.centerIn: parent
            width: 200
            height: 100
            radius: 10
            color: theme.primary.background
            border.color: theme.button.border
            border.width: 2
            visible: !listAppsProccess.running && root.apps.length === 0
            
            Column {
                anchors.centerIn: parent
                spacing: 10
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "📂"
                    font.pixelSize: 30
                    color: theme.primary.dim_foreground
                }
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: lang.lockscreen?.no_apps || "No applications found"
                    color: theme.primary.dim_foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 12
                    }
                }
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 20

            // Title
            Text {
                text: lang.lockscreen?.title || "Lock Screen"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 24
                    bold: true
                }
                Layout.topMargin: 10
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.foreground
            }

            // User Information Section
            Text {
                text: lang.lockscreen?.user_info || "User Information"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 20
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
                        pixelSize: 16
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
                        pixelSize: 16
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
                        pixelSize: 16
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
                        panelConfig.set("lockscreen.username", text)
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
                    pixelSize: 20
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
                        pixelSize: 16
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
                    pixelSize: 20
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
                            source: ""
                            fillMode: Image.PreserveAspectFit
                            smooth: true
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
                    pixelSize: 20
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
                            source: ""
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
    
    // Helper functions for app grid
    function getAppName(execPath) {
        // Extract app name from exec path
        if (!execPath) return ""
        
        // Remove path and arguments
        var name = execPath.split('/').pop().split(' ')[0]
        
        // Remove common prefixes and file extensions
        name = name.replace(/^\.\//, '') // Remove ./
        name = name.replace(/\.(exe|bin|sh|py|pl)$/, '') // Remove extensions
        
        // Capitalize first letter
        if (name.length > 0) {
            name = name.charAt(0).toUpperCase() + name.slice(1)
        }
        
        return name
    }
    
    function filterApps() {
        if (!searchField.text) {
            return root.apps
        }
        
        var searchText = searchField.text.toLowerCase()
        return root.apps.filter(function(app) {
            var execName = getAppName(app.exec).toLowerCase()
            return execName.includes(searchText)
        })
    }
}
