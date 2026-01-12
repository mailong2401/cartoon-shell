import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: container
    radius: currentSizes.launcherPanel?.radius || currentSizes.radius?.normal || 12
    color: theme.primary.dim_background
    border.color: theme.normal.black
    border.width: 2

    property var apps: []
    property var allApps: []
    property string lastQuery: ""
    property var theme : currentTheme
    property int currentIndex: 0

    signal appLaunched()

    // Sử dụng Repeater để convert ObjectModel thành array
    Repeater {
        id: appRepeater
        model: DesktopEntries.applications

        Item {
            Component.onCompleted: {
                container.allApps.push({
                    name: modelData.name || "",
                    comment: modelData.comment || "",
                    icon: modelData.icon || "",
                    entry: modelData
                })
            }
        }
    }

    Connections {
        target: DesktopEntries
        function onApplicationsChanged() {
            container.allApps = []
            // Repeater sẽ tự động reload
        }
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            container.allApps.sort(function(a, b) {
                return a.name.toLowerCase().localeCompare(b.name.toLowerCase())
            })
            container.apps = container.allApps
        })
    }

    ColumnLayout {
        id: rootLayout
        anchors.fill: parent
        anchors.margins: currentSizes.launcherPanel?.listLayoutMargins || 8
        spacing: currentSizes.launcherPanel?.spacing || 6

        ListView {
    id: appList
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    spacing: currentSizes.launcherPanel?.listSpacing || 4
    model: container.apps
    currentIndex: container.currentIndex
    focus: true
    keyNavigationWraps: true

    delegate: Rectangle {
        width: ListView.view.width
        height: currentSizes.launcherPanel?.listItemHeight || 56
        radius: currentSizes.launcherPanel?.listItemRadius || 8
        color: (ListView.isCurrentItem || mouseArea.containsMouse)
               ? theme.button.background_select
               : "transparent"
        border.color: (ListView.isCurrentItem || mouseArea.containsMouse)
                      ? theme.button.border_select
                      : "transparent"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: currentSizes.launcherPanel?.listItemMargins || 8
            spacing: currentSizes.launcherPanel?.listItemSpacing || 10

            Image {
                Layout.preferredWidth: currentSizes.launcherPanel?.listItemIconSize || 36
                Layout.preferredHeight: currentSizes.launcherPanel?.listItemIconSize || 36
                fillMode: Image.PreserveAspectFit
                source: modelData.icon ? "image://icon/" + modelData.icon : ""
                asynchronous: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: modelData.name || "Unknown"
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: currentSizes.launcherPanel?.listItemTitleFontSize || 20
                    elide: Text.ElideRight
                }

                Text {
                    text: modelData.comment || ""
                    color: theme.primary.bright_foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: currentSizes.launcherPanel?.listItemCommentFontSize || 13
                    elide: Text.ElideRight
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (modelData && modelData.entry) {
                    modelData.entry.execute()
                    container.appLaunched()
                }
            }
            onEntered: {
                if (ListView.view) {
                    ListView.view.currentIndex = index
                }
            }
        }
    }

    }


        Text {
            visible: container.apps.length === 0
            text: "Không có kết quả"
            color: "#777"
            font.pixelSize: currentSizes.fontSize?.normal || 14
            font.family: "ComicShannsMono Nerd Font"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }

    function runSearch(query) {
        if (query === undefined || query === null) query = ""
        container.lastQuery = query

        if (query.length === 0) {
            container.apps = container.allApps
            container.currentIndex = 0
            return
        }

        var q = query.toLowerCase()
        var filtered = []

        for (var i = 0; i < container.allApps.length; i++) {
            var app = container.allApps[i]
            var name = (app.name || "").toLowerCase()
            var comment = (app.comment || "").toLowerCase()

            if (name.indexOf(q) >= 0 || comment.indexOf(q) >= 0) {
                filtered.push(app)
            }
        }

        container.apps = filtered
        container.currentIndex = 0
    }

    Shortcut {
        sequence: "Tab"
        onActivated: {
          container.currentIndex = (container.currentIndex + 1) % container.apps.length
          appList.currentIndex = container.currentIndex
        }
      }
      Shortcut {
        sequence: "Up"
        onActivated: {
          container.currentIndex = Math.max(container.currentIndex - 1, 0)
            appList.currentIndex = container.currentIndex
        }
      }
      Shortcut {
        sequence: "Down"
        onActivated: {
          container.currentIndex = (container.currentIndex + 1) % container.apps.length
          appList.currentIndex = container.currentIndex
        }
      }
      Shortcut {
    sequence: "Return"
    onActivated: {
        if (container.apps.length > 0 && container.currentIndex < container.apps.length) {
            var item = container.apps[container.currentIndex]
            if (item && item.entry) {
                item.entry.execute()
                container.appLaunched()
            }
        }
    }
}

}