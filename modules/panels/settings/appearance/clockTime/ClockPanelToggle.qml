// components/Settings/ClockPanelToggle.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: clockPanelToggle
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig
    width: parent?.width
    
    spacing: 10

    Text {
        text: lang.appearance?.clock_panel_label || "Bảng đồng hồ:"
        color: theme.primary.foreground
        font.family: "ComicShannsMono Nerd Font"
        font.pixelSize: 16
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
    }

    Item { Layout.fillWidth: true }

    Switch {
        id: autoStartSwitch
        checked: currentConfig.clockPanelVisible || false
        onToggled: {
            panelConfig.set("clockPanelVisible", checked)
            Qt.callLater(function() {
                configLoader.loadConfig()
            })
        }
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

        background: Rectangle {
            implicitWidth: 48
            implicitHeight: 28
            radius: 14
            color: autoStartSwitch.checked ? theme.normal.blue : theme.button.background
            border.color: autoStartSwitch.checked ? theme.normal.blue : theme.button.border
            border.width: 2
        }

        indicator: Rectangle {
            x: autoStartSwitch.checked ? parent.background.width - width - 4 : 4
            y: (parent.background.height - height) / 2
            width: 20
            height: 20
            radius: 10
            color: theme.primary.background

            Behavior on x {
                NumberAnimation { duration: 150 }
            }
        }
    }
}
