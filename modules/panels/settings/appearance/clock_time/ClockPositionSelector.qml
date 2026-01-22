// components/Settings/ClockPositionSelector.qml
import QtQuick
import QtQuick.Layouts

Column {
    id: clockPositionSelector
    property var theme
    property var lang
    property var currentConfig
    
    signal positionSelected(string position)
    
    spacing: 15

    RowLayout {
        width: parent.width
        
        Text {
            text: lang.appearance?.clock_position_label || "Vị trí đồng hồ:"
            color: theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: 16
            }
            Layout.preferredWidth: 150
        }
        
        Item { Layout.fillWidth: true }
    }

    Column {
        spacing: 15
        width: parent.width

        // Hàng trên cùng
        Row {
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter
            
            ClockPositionButton {
                position: "topLeft"
                isSelected: currentConfig.clockPanelPosition === "topLeft"
                theme: clockPositionSelector.theme
                anchorConfig: { top: true, left: true }
                onClicked: clockPositionSelector.positionSelected("topLeft")
            }

            ClockPositionButton {
                position: "top"
                isSelected: currentConfig.clockPanelPosition === "top"
                theme: clockPositionSelector.theme
                anchorConfig: { top: true, hCenter: true }
                onClicked: clockPositionSelector.positionSelected("top")
            }

            ClockPositionButton {
                position: "topRight"
                isSelected: currentConfig.clockPanelPosition === "topRight"
                theme: clockPositionSelector.theme
                anchorConfig: { top: true, right: true }
                onClicked: clockPositionSelector.positionSelected("topRight")
            }
        }

        // Hàng giữa
        Row {
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter
            
            ClockPositionButton {
                position: "left"
                isSelected: currentConfig.clockPanelPosition === "left"
                theme: clockPositionSelector.theme
                anchorConfig: { left: true, vCenter: true }
                onClicked: clockPositionSelector.positionSelected("left")
            }

            ClockPositionButton {
                position: "center"
                isSelected: currentConfig.clockPanelPosition === "center"
                theme: clockPositionSelector.theme
                anchorConfig: { hCenter: true, vCenter: true }
                onClicked: clockPositionSelector.positionSelected("center")
            }

            ClockPositionButton {
                position: "right"
                isSelected: currentConfig.clockPanelPosition === "right"
                theme: clockPositionSelector.theme
                anchorConfig: { right: true, vCenter: true }
                onClicked: clockPositionSelector.positionSelected("right")
            }
        }

        // Hàng dưới cùng
        Row {
            spacing: 15
            anchors.horizontalCenter: parent.horizontalCenter
            
            ClockPositionButton {
                position: "bottomLeft"
                isSelected: currentConfig.clockPanelPosition === "bottomLeft"
                theme: clockPositionSelector.theme
                anchorConfig: { bottom: true, left: true }
                onClicked: clockPositionSelector.positionSelected("bottomLeft")
            }

            ClockPositionButton {
                position: "bottom"
                isSelected: currentConfig.clockPanelPosition === "bottom"
                theme: clockPositionSelector.theme
                anchorConfig: { bottom: true, hCenter: true }
                onClicked: clockPositionSelector.positionSelected("bottom")
            }

            ClockPositionButton {
                position: "bottomRight"
                isSelected: currentConfig.clockPanelPosition === "bottomRight"
                theme: clockPositionSelector.theme
                anchorConfig: { bottom: true, right: true }
                onClicked: clockPositionSelector.positionSelected("bottomRight")
            }
        }
    }
}
