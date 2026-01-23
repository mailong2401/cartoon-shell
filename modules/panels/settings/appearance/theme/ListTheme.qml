import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

ColumnLayout {
    id: presetThemesContainer
    property var theme: currentTheme
    property var panelConfig
    
    width: parent.width
    spacing: 15
    property Timer reloadTimer: Timer {
        interval: 100
        repeat: false
        onTriggered: themeLoader.loadTheme()
    }
    
    Text {
        text: "Preset Themes"
        color: theme.primary.foreground
        font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 18
            bold: true
        }
        Layout.alignment: Qt.AlignLeft
    }
    
    GridLayout {
        Layout.fillWidth: true
        columns: panelManager.fullsetting ? 5 : 3
        columnSpacing: panelManager.fullsetting ? 15 : 10
        rowSpacing: panelManager.fullsetting ? 15 : 10
        
        Repeater {
    model: [
        { name: "Auto",        type: "matugen",        accent: "black" },
        { name: "Macchiato",    type: "macchiato",    accent: "#24273a" },
        { name: "Gruvbox",      type: "gruvbox",      accent: "#f5eee6" },
        { name: "Tokyonight Storm", type: "tokyonightStorm", accent: "#7aa2f7" },
        { name: "Nord",       type: "nord",       accent: "#88c0d0" },
        { name: "Catppuccin", type: "catppuccin", accent: "#f5e0dc" },
        { name: "Rose Pine",  type: "rosepine",   accent: "#eb6f92" },
        { name: "Everforest", type: "everforest", accent: "#a7c080" },
        { name: "Kanagawa",   type: "kanagawa",   accent: "#957fb8" }
    ]

            
            delegate: Rectangle {
    id: themeDelegate
    Layout.fillWidth: true
    Layout.preferredHeight: 60
    radius: 8
    color: theme.button.background
    border {
        color: theme.button.border
        width: 2
    }

    // 👇 modal đúng như bạn muốn
    property var modal: ({
        name: modelData.name,
        type: modelData.type,
        accent: modelData.accent
    })

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            panelConfig.set("theme", modal.type)
            reloadTimer.restart()
            
        }
    }

    // ✔ checkmark theme đang active
    Rectangle {
        visible: configLoader.config.theme === modal.type
        width: 20
        height: 20
        radius: 10
        color: theme.normal.blue
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5

        Text {
            text: "✓"
            color: theme.primary.background
            font.pixelSize: 12
            font.bold: true
            anchors.centerIn: parent
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 6
            color: modal.accent
        }

        Text {
    text: modal.name
    color: theme.primary.foreground
    wrapMode: Text.WordWrap
    width: 40
    horizontalAlignment: Text.AlignLeft

    font {
        family: "ComicShannsMono Nerd Font"
        pixelSize: panelManager.fullsetting ? 16 : 12
        bold: true
    }
}

    }

            }
        }
    }
}
