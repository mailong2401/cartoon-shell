import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
import qs.services

Item {
    id: systemSettings
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig  // Received from parent SettingsPanel

    property string homePath: ""
    property string wallpapersPath: ""
    property string wallpaperPath: ""
    property string currentWallpaper: ""
    property string pendingMatugenPath: ""


    Matugen {
        id: matugenHandler
    }


    // Process để lấy home directory
    Process {
        id: getHomeProcess
        command: ["bash", "-c", "echo $HOME"]
        running: true
        stdout: StdioCollector {
            id: homeOutput
            onTextChanged: {
                if (text) {
                    var path = text.trim()
                    systemSettings.homePath = path
                    systemSettings.wallpapersPath = "file://" + path + "/Pictures/Wallpapers/"
                }
            }
        }
    }

    // Process để set wallpaper
    Process {
        id: wallpaperProcess

        stdout: StdioCollector {
            onTextChanged: { }
        }

        onRunningChanged: {
            if (!running) {
                currentWallpaper = wallpaperPath
                showNotification(lang?.wallpapers?.success_set || "Đã đặt hình nền thành công!")
                folderModel.update()
            }
        }
    }

    // Process để xóa file
    Process {
        id: deleteProcess
        command: ["rm", ""]

        stdout: StdioCollector {
            onTextChanged: { }
        }

        onRunningChanged: {
            if (!running) {
                showNotification(lang?.wallpapers?.success_delete || "Đã xóa ảnh thành công!")
            }
        }
    }

    // Process để tạo thumbnail cho video
    Process {
    id: thumbnailProcess

    onRunningChanged: {
        if (!running && pendingMatugenPath !== "") {
            console.log("Thumbnail ready:", pendingMatugenPath)
            matugenHandler.triggerMatugenOnWallpaperChange(pendingMatugenPath)
            pendingMatugenPath = ""
        }
    }
}


    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        
        ColumnLayout {
            width: parent.width
            spacing: 15
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Text {
                    text: lang?.wallpapers?.title || "Quản lý hình ảnh"
                    color: theme.primary.foreground
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
                
                Item {
                    Layout.fillWidth: true
                }
                
                Button {
                    id: advancedButton
                    visible: !panelManager.fullsetting
                    text: "Nâng cao"
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 14
                    
                    background: Rectangle {
                        color: advancedButton.hovered ? theme.button.hover : theme.button.background
                        border.color: theme.button.border
                        border.width: 1
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: advancedButton.text
                        font: advancedButton.font
                        color: theme.primary.foreground
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        panelManager.togglePanel("fullsetting")
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.foreground
            }
            
            // Statistics
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                
                Rectangle {
                    Layout.preferredHeight: 40
                    Layout.fillWidth: true
                    radius: 8
                    color: theme.button.background
                    border.color: theme.button.border
                    border.width: 2

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: lang?.wallpapers?.total_images || "Tổng số ảnh:"
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 15
                        }

                        Text {
                            text: folderModel.count
                            color: theme.normal.blue
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 18
                            font.bold: true
                        }
                        
                        Text {
                            text: "|"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 15
                        }
                        
                        Text {
                            text: homePath ? (lang?.wallpapers?.path || "Đường dẫn:") + " ~/Pictures/Wallpapers/" : (lang?.wallpapers?.loading || "Đang tải...")
                            font.family: "ComicShannsMono Nerd Font"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 15
                            elide: Text.ElideMiddle
                        }
                    }
                }
            }
            
            // Wallpapers Section
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Text {
                    text: lang?.wallpapers?.wallpapers_label || "Hình nền:"
                    color: theme.primary.foreground
                    font {
                        family: "ComicShannsMono Nerd Font"
                        pixelSize: 16
                    }
                }
                
                // Wallpapers Grid
                Grid {
                    id: wallpapersGrid
                    Layout.fillWidth: true
                    columns: !panelManager.fullsetting ? 3 : 6
                    columnSpacing: !panelManager.fullsetting ? 8 : 10
                    rowSpacing: !panelManager.fullsetting ? 8 : 10
                    
                    Repeater {
                        model: FolderListModel {
                            id: folderModel
                            folder: wallpapersPath
                            nameFilters: ["*.jpg","*.jpeg","*.png","*.bmp","*.webp","*.gif","*.mp4","*.webm","*.mkv","*.avi","*.mov","*.flv","*.wmv","*.m4v","*.mpg","*.mpeg"]
                            showDirs: false
                            sortField: FolderListModel.Name
                        }
                        
                        delegate: Rectangle {
                            width: !panelManager.fullsetting ? systemSettings.width/4 : systemSettings.width/7
                            height: !panelManager.fullsetting ? systemSettings.width/4 : systemSettings.width/7
                            radius: 12
                            color: theme.button.background
                            border.color: theme.button.border
                            border.width: 1

                            Column {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8

                                // Thumbnail
                                Rectangle {
                                    width: parent.width
                                    height: parent.height - 70
                                    radius: 8
                                    clip: true
                                    color: "transparent"

                                    Component.onCompleted: {
                                        if (isVideoFile(fileName)) {
                                            generateThumbnail(filePath)
                                        }
                                    }

                                    Image {
                                        id: thumbnailImage
                                        anchors.fill: parent
                                        source: isVideoFile(fileName) ? getThumbnailPath(filePath) : filePath
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true
                                        cache: false
                                        smooth: true
                                        mipmap: true

                                        onStatusChanged: {
                                            if (status === Image.Error && isVideoFile(fileName)) {
                                                // Nếu thumbnail chưa có, thử tạo lại
                                                thumbnailImage.source = ""
                                                generateThumbnail(filePath)
                                            }
                                        }
                                    }

                                    // Video indicator
                                    Rectangle {
                                        visible: isVideoFile(fileName)
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.margins: 5
                                        width: 24
                                        height: 24
                                        radius: 12
                                        color: theme.normal.magenta

                                        Text {
                                            text: "▶"
                                            color: theme.primary.background
                                            font.pixelSize: 12
                                            font.bold: true
                                            anchors.centerIn: parent
                                        }
                                    }

                                    // Current Wallpaper Indicator
                                    Rectangle {
                                        visible: isCurrentWallpaper(filePath)
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.margins: 5
                                        width: 24
                                        height: 24
                                        radius: 12
                                        color: theme.normal.green

                                        Text {
                                            text: "✓"
                                            color: theme.primary.background
                                            font.pixelSize: 12
                                            font.bold: true
                                            anchors.centerIn: parent
                                        }
                                    }
                                }

                                // File Info & Actions
                                Column {
                                    width: parent.width
                                    spacing: 6

                                    Text {
                                        text: fileName
                                        color: theme.primary.foreground
                                        font.pixelSize: 12
                                        elide: Text.ElideMiddle
                                        width: parent.width
                                    }

                                    Row {
                                        width: parent.width
                                        spacing: 8
                                        Text {
                                            text: Math.round(fileSize / 1024) + " KB"
                                            color: theme.primary.dim_foreground
                                            font.pixelSize: 9
                                        }
                                        Text {
                                            text: new Date(fileModified).toLocaleDateString(Qt.locale(), "dd/MM/yyyy")
                                            color: theme.primary.dim_foreground
                                            font.pixelSize: 9
                                        }
                                    }

                                    Row {
                                        width: parent.width
                                        spacing: 6

                                        // Set Wallpaper
                                        Rectangle {
                                            width: (parent.width - 6) / 2
                                            height: 28
                                            radius: 6
                                            color: isCurrentWallpaper(filePath) ? theme.normal.green : theme.normal.blue

                                            Text {
                                                anchors.centerIn: parent
                                                text: isCurrentWallpaper(filePath) ? (lang?.wallpapers?.already_set || "Đã đặt") : (lang?.wallpapers?.set_wallpaper || "Đặt nền")
                                                color: theme.primary.background
                                                font.pixelSize: 10
                                                font.bold: true
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: setWallpaper(filePath)
                                            }
                                        }

                                        // Delete Button
                                        Rectangle {
                                            width: (parent.width - 6) / 2
                                            height: 28
                                            radius: 6
                                            color: theme.normal.red

                                            Text {
                                                anchors.centerIn: parent
                                                text: lang?.wallpapers?.delete || "Xóa"
                                                color: theme.primary.background
                                                font.pixelSize: 10
                                                font.bold: true
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: showDeleteDialog(fileName, filePath)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // No images message
                Text {
                    visible: folderModel.count === 0 && homePath
                    text: lang?.wallpapers?.no_images || "Không tìm thấy ảnh nào trong thư mục ~/Pictures/Wallpapers"
                    color: theme.primary.dim_foreground
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignCenter
                }

                // Loading message
                Text {
                    visible: !homePath
                    text: lang?.wallpapers?.loading_info || "Đang tải thông tin..."
                    color: theme.primary.dim_foreground
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignCenter
                }
            }
            
            Item { Layout.fillHeight: true } // Spacer
        }
    }

    // Delete dialog
    Rectangle {
        id: deleteDialog
        visible: false
        anchors.centerIn: parent
        width: 300
        height: 160
        radius: 12
        color: theme.primary.background
        border.color: theme.normal.red
        border.width: 2
        z: 1000

        property string fileNameToDelete: ""
        property string filePathToDelete: ""

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: (lang?.wallpapers?.delete_confirm || "Xác nhận xóa") + "\n" + deleteDialog.fileNameToDelete
                color: theme.normal.red
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                // Cancel
                Rectangle {
                    width: 100
                    height: 35
                    radius: 6
                    color: theme.button.background
                    border.color: theme.button.border

                    Text {
                        anchors.centerIn: parent;
                        text: lang?.wallpapers?.cancel || "Hủy";
                        color: theme.primary.foreground
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: deleteDialog.visible = false
                    }
                }

                // Confirm delete
                Rectangle {
                    width: 100
                    height: 35
                    radius: 6
                    color: theme.normal.red

                    Text {
                        anchors.centerIn: parent;
                        text: lang?.wallpapers?.delete || "Xóa";
                        color: theme.primary.background
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            deleteWallpaper(deleteDialog.filePathToDelete)
                            deleteDialog.visible = false
                        }
                    }
                }
            }
        }
    }

    // Notification
    Rectangle {
        id: successNotification
        visible: false
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        width: 250
        height: 50
        radius: 8
        color: theme.normal.green
        z: 1001

        Row {
            anchors.centerIn: parent;
            spacing: 10
            Text {
                text: "✓";
                color: theme.primary.background;
                font.bold: true;
                font.pixelSize: 16
            }
            Text {
                id: notificationText;
                color: theme.primary.background;
                text: "";
                font.bold: true;
                font.pixelSize: 16
            }
        }

        Timer {
            id: notificationTimer;
            interval: 3000;
            onTriggered: successNotification.visible = false
        }
    }

    function setWallpaper(filePath) {
    wallpaperPath = filePath.toString().replace("file://", "")
    panelConfig.set("pictureWallpaper", wallpaperPath)

    wallpaperProcess.command = [
        Qt.resolvedUrl("../../../../scripts/select_wall"),
        wallpaperPath
    ]
    wallpaperProcess.running = true

    if (!isVideoFile(wallpaperPath)) {
        matugenHandler.triggerMatugenOnWallpaperChange(wallpaperPath)
    } else {
        pendingMatugenPath = getThumbnailPath(filePath).replace("file://", "")
        generateThumbnail(filePath)
    }
}


    function generateThumbnail(filePath) {
        if (!homePath) return
        var actualPath = filePath.toString().replace("file://", "")
        var thumbnailDir = homePath + "/.config/hypr/custom/scripts/mpvpaper_thumbnails"
        var fileName = actualPath.split('/').pop()
        var thumbnailPath = thumbnailDir + "/" + fileName + ".jpg"
        var scriptPath = homePath + "/.config/quickshell/cartoon-shell/scripts/generate-video-thumbnail.sh"

        thumbnailProcess.command = [
            "bash",
            scriptPath,
            actualPath,
            thumbnailPath
        ]
        thumbnailProcess.running = true
    }

    function isVideoFile(fileName) {
        var ext = fileName.toLowerCase().split('.').pop()
        return ["mp4", "webm", "mkv", "avi", "mov", "flv", "wmv", "m4v", "mpg", "mpeg"].includes(ext)
    }

    function getThumbnailPath(filePath) {
        if (!homePath) return ""
        var actualPath = filePath.toString().replace("file://", "")
        var thumbnailDir = homePath + "/.config/hypr/custom/scripts/mpvpaper_thumbnails"
        var fileName = actualPath.split('/').pop()
        return "file://" + thumbnailDir + "/" + fileName + ".jpg"
    }

    function deleteWallpaper(filePath) {
        var actualPath = filePath.toString().replace("file://", "")

        deleteProcess.command = ["rm", actualPath]
        deleteProcess.running = true
    }

    function showDeleteDialog(fileName, filePath) {
        deleteDialog.fileNameToDelete = fileName
        deleteDialog.filePathToDelete = filePath
        deleteDialog.visible = true
    }

    function showNotification(message) {
        notificationText.text = message
        successNotification.visible = true
        notificationTimer.start()
    }

    function isCurrentWallpaper(filePath) {
        return currentConfig.pictureWallpaper === filePath
    }

    Component.onCompleted: {
    }
}
