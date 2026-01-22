// components/Settings/ClockPositionSelector.qml
import QtQuick
import QtQuick.Layouts
import "." as Com

Item {
    id: clockPositionSelector
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig
    
    signal positionSelected(string position)
    
    implicitHeight: content.implicitHeight
    
    ColumnLayout {
        id: content
        width: parent.width
        spacing: 0
        
        // Label row
        RowLayout {
            id: labelContainer
            Layout.fillWidth: true
            
            Text {
                id: label
                text: lang.appearance?.clock_position_label || "Vị trí đồng hồ:"
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 18
                    bold: true
                }
                Layout.preferredWidth: 200
            }
            
            Item { Layout.fillWidth: true }
        }
        
        // Grid container lớn hơn
        Rectangle {
            id: positionContainer
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(parent.width * 0.8, 400)
            color: "transparent"
            
            Grid {
                id: positionGrid
                anchors.centerIn: parent
                columns: 3
                rows: 3
                spacing: 25
                
                // Hàng 1
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "topLeft"
                    isSelected: currentConfig.clockPanelPosition === "topLeft"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ top: true, left: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "topLeft")
                        positionSelected("topLeft")
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "top"
                    isSelected: currentConfig.clockPanelPosition === "top"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ top: true, hCenter: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "top")
                        positionSelected("top")
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "topRight"
                    isSelected: currentConfig.clockPanelPosition === "topRight"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ top: true, right: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "topRight")
                        positionSelected("topRight")
                    }
                }
                
                // Hàng 2
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "left"
                    isSelected: currentConfig.clockPanelPosition === "left"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ left: true, vCenter: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "left")
                        positionSelected("left")
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "center"
                    isSelected: currentConfig.clockPanelPosition === "center"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ hCenter: true, vCenter: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "center")
                        positionSelected("center")
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "right"
                    isSelected: currentConfig.clockPanelPosition === "right"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ right: true, vCenter: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "right")
                        positionSelected("right")
                    }
                }
                
                // Hàng 3
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottomLeft"
                    isSelected: currentConfig.clockPanelPosition === "bottomLeft"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ bottom: true, left: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "bottomLeft")
                        positionSelected("bottomLeft")
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottom"
                    isSelected: currentConfig.clockPanelPosition === "bottom"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ bottom: true, hCenter: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "bottom")
                        positionSelected("bottom")
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottomRight"
                    isSelected: currentConfig.clockPanelPosition === "bottomRight"
                    theme: clockPositionSelector.theme
                    anchorConfig: ({ bottom: true, right: true })
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "bottomRight")
                        positionSelected("bottomRight")
                    }
                }
            }
        }
        
        // Phần mô tả vị trí được chọn
        Rectangle {
            id: positionDescription
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: theme.primary.background
            radius: 8
            visible: currentConfig.clockPanelPosition
            
            Text {
                anchors.centerIn: parent
                text: {
                    var pos = currentConfig.clockPanelPosition;
                    var descriptions = {
                        "topLeft": "Trên cùng bên trái",
                        "top": "Trên cùng giữa",
                        "topRight": "Trên cùng bên phải",
                        "left": "Bên trái giữa",
                        "center": "Chính giữa màn hình",
                        "right": "Bên phải giữa",
                        "bottomLeft": "Dưới cùng bên trái",
                        "bottom": "Dưới cùng giữa",
                        "bottomRight": "Dưới cùng bên phải"
                    };
                    return descriptions[pos] || "Vị trí: " + pos;
                }
                color: theme.primary.foreground
                font {
                    family: "ComicShannsMono Nerd Font"
                    pixelSize: 14
                }
            }
        }
    }
}
