import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    property int currentTab: 0
    property var theme: currentTheme
    property var lang: currentLanguage
    Layout.fillWidth: true
    color: theme.primary.dim_background
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10
        
        // Danh mục tab với icon
        Repeater {
            model: [
                { name: lang.appearance?.theme || "Theme", icon: "../../../../assets/settings/home.png", category: "theme" },
                { name: lang.appearance?.panel || "Panel", icon: "../../../../assets/settings/home.png", category: "panel" },
                { name: lang.appearance?.clock || "Clock", icon: "../../../../assets/settings/home.png", category: "clock" },
                { name: lang.appearance?.fonts || "Fonts", icon: "../../../../assets/settings/home.png", category: "fonts" },
                { name: lang.appearance?.icons || "Icons", icon: "../../../../assets/settings/home.png", category: "icons" },
                { name: lang.appearance?.effects || "Effects", icon: "../../../../assets/settings/home.png", category: "effects" },
                { name: lang.appearance?.layout || "Layout", icon: "../../../../assets/settings/home.png", category: "layout" },
                { name: lang.appearance?.wallpaper || "Wallpaper", icon: "../../../../assets/settings/home.png", category: "wallpaper" },
            ]

            delegate: Rectangle {
                id: tabDelegate
                Layout.preferredWidth: panelManager.fullsetting ? 110 : 50
                Layout.fillHeight: true
                radius: 8
                
                property bool hovered: false
                property bool selected: root.currentTab === index

                color: mouseArea.containsPress ? theme.button.background_select : 
                       hovered ? theme.button.background_select : 
                       selected ? theme.button.background_select: theme.primary.background
                
                border.color: mouseArea.containsPress ? theme.primary.foreground : 
                             hovered ? theme.normal.blue : 
                             selected ? theme.primary.foreground : theme.button.border
                border.width: 2
                
                // Hiệu ứng scale
                scale: mouseArea.containsPress ? 0.98 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
                
                // Hiệu ứng màu
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on border.color { ColorAnimation { duration: 100 } }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8
                    
                    // Thêm icon vào đây
                    Image {
                        source: modelData.icon
                        Layout.preferredHeight: 22
                        Layout.preferredWidth: 22
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        
                        // Hiệu ứng xoay icon khi hover
                        rotation: hovered ? (index % 2 === 0 ? 10 : -10) : 0
                        Behavior on rotation { 
                            NumberAnimation { 
                                duration: 300; 
                                easing.type: Easing.OutBack 
                            } 
                        }
                        
                        // Hiệu ứng scale icon khi hover
                        scale: hovered ? 1.1 : 1.0
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 200; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                    }

                    Text {
                        text: modelData.name
                        visible: panelManager.fullsetting
                        color: hovered ? theme.primary.bright_foreground : 
                               selected ? theme.primary.bright_foreground : theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 14
                            bold: selected || hovered
                        }
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        
                        // Hiệu ứng scale text khi hover
                        scale: hovered ? 1.05 : 1.0
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 200; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        root.currentTab = index
                    }

                    onEntered: tabDelegate.hovered = true
                    onExited: tabDelegate.hovered = false
                }
            }
        }

        Item { Layout.fillHeight: true } // Spacer
    }
}
