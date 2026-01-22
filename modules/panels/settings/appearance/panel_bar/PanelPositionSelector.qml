// components/Settings/PanelPositionSelector.qml
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: panelPositionSelector
    property var theme
    property var lang
    property var panelConfig
    
    Text {
        text: lang.appearance?.panel_position_label || "Vị trí panel:"
        color: theme.primary.foreground
        font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 16
        }
        Layout.preferredWidth: 150
    }

    Row {
        spacing: 15
        Layout.fillWidth: true

        PositionButton {
            label: lang.appearance?.position_top || "Trên"
            position: "top"
            isSelected: currentConfig.mainPanelPos === "top"
            theme: panelPositionSelector.theme
            onClicked: panelConfig.set("mainPanelPos", "top")
        }

        PositionButton {
            label: lang.appearance?.position_bottom || "Dưới"
            position: "bottom"
            isSelected: currentConfig.mainPanelPos === "bottom"
            theme: panelPositionSelector.theme
            onClicked: panelConfig.set("mainPanelPos", "bottom")
        }
    }
}
