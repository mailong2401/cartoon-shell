import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: container
    radius: 12
    color: theme.primary.dim_background
    border.color: theme.button.border
    border.width: 2

    property var apps: []
    property var filteredApps: []
    property string lastQuery: ""
    property var theme : currentTheme
    property int currentIndex: 0


    signal appLaunched()

    ColumnLayout {
        id: rootLayout
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Process {
            id: listApps
            running: false
            stdout: StdioCollector { id: outputCollector }

            onExited: {
                try {
                    var txt = outputCollector.text ? outputCollector.text.trim() : ""
                    if (txt !== "") {
                      container.apps = JSON.parse(txt)
                      container.filteredApps = container.apps
                    } else {
                      container.apps = []
                      container.filteredApps = []
                    }
                } catch(e) {
                  container.apps = []
                  container.filteredApps = []
                }
            }
        }

        Component.onCompleted: {
          listApps.command = [Qt.resolvedUrl("../../../scripts/listapps.py")]
          listApps.running = true
        }

        ListView {
    id: appList
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    spacing: 4
    model: container.filteredApps
    currentIndex: container.currentIndex
    focus: true
    keyNavigationWraps: true

    delegate: Rectangle {
        width: ListView.view.width
        height: 56
        radius: 8
        color: (ListView.isCurrentItem || mouseArea.containsMouse)
               ? theme.button.background_select
               : "transparent"
        border.color: (ListView.isCurrentItem || mouseArea.containsMouse)
                      ? theme.button.border_select
                      : "transparent"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 10

            Image {
                Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                fillMode: Image.PreserveAspectFit
                source: "image://icon/" + modelData.icon || ""
                asynchronous: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: modelData.name || "Unknown"
                    color: theme.primary.foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 20
                    elide: Text.ElideRight
                }

                Text {
                    text: modelData.comment || ""
                    color: theme.primary.bright_foreground
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 13
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
                var item = modelData
                if (item && item.exec) {
                    container.launchApplication(item.exec)
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
            font.pixelSize: 14
            font.family: "ComicShannsMono Nerd Font"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }

    function runSearch(query) {
    if (!query || query.length === 0) {
        container.filteredApps = container.apps
        container.currentIndex = 0
        return
    }

    var q = query.toLowerCase()
    container.filteredApps = container.apps.filter(app =>
        (app.name && app.name.toLowerCase().includes(q)) ||
        (app.exec && app.exec.toLowerCase().includes(q)) ||
        (app.comment && app.comment.toLowerCase().includes(q))
    )

    container.currentIndex = 0
}


    function _splitArgs(cmd) {
        var parts = []
        var re = /"([^"]*)"|'([^']*)'|([^ \t"']+)/g
        var m
        while ((m = re.exec(cmd)) !== null) {
            if (m[1] !== undefined) parts.push(m[1])
            else if (m[2] !== undefined) parts.push(m[2])
            else if (m[3] !== undefined) parts.push(m[3])
        }
        return parts
    }

    function launchApplication(execStrOrItem) {
        try {
            var execStr = ""
            if (typeof execStrOrItem === "object" && execStrOrItem !== null) {
                execStr = execStrOrItem.exec || execStrOrItem.command && execStrOrItem.command.join(" ") || ""
            } else if (typeof execStrOrItem === "string") {
                execStr = execStrOrItem
            } else {
                return
            }

            if (!execStr || execStr.trim() === "") {
                return
            }

            execStr = execStr.replace(/%[fFuUdDinkcK%]/g, "").trim()
            var cmdArray = _splitArgs(execStr)

            if (!cmdArray || cmdArray.length === 0) {
                return
            }

            Quickshell.execDetached(cmdArray)
        } catch (err) {
        }
    }

    Shortcut {
        sequence: "Tab"
        onActivated: {
          container.currentIndex = (container.currentIndex + 1) % container.filteredApps.length
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
          container.currentIndex = (container.currentIndex + 1) % container.filteredApps.length
          appList.currentIndex = container.currentIndex
        }
      }
      Shortcut {
    sequence: "Return"    // hoặc "Enter" đều được
    onActivated: {
                var item = container.filteredApps[container.currentIndex]
                container.launchApplication(item.exec)
                container.appLaunched()
    }
}

}
