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
    
    implicitHeight: positionContainer.height + labelContainer.height + positionDescription.height + 40
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 20
        
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
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "topLeft")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "top"
                    isSelected: currentConfig.clockPanelPosition === "top"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "top")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "topRight"
                    isSelected: currentConfig.clockPanelPosition === "topRight"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "topRight")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                // Hàng 2
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "left"
                    isSelected: currentConfig.clockPanelPosition === "left"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "left")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "center"
                    isSelected: currentConfig.clockPanelPosition === "center"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "center")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "right"
                    isSelected: currentConfig.clockPanelPosition === "right"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "right")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                // Hàng 3
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottomLeft"
                    isSelected: currentConfig.clockPanelPosition === "bottomLeft"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "bottomLeft")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottom"
                    isSelected: currentConfig.clockPanelPosition === "bottom"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "bottom")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
                
                Com.ClockPositionButton {
                    width: 80
                    height: 80
                    position: "bottomRight"
                    isSelected: currentConfig.clockPanelPosition === "bottomRight"
                    theme: clockPositionSelector.theme
                    onClicked: {
                        panelConfig.set("clockPanelPosition", "bottomRight")
                        Qt.callLater(function() {
                            configLoader.loadConfig()
                        })
                    }
                }
            }
        }
        

    }
}
