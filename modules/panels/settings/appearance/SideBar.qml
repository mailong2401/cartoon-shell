import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
  property int currentTab: 0
  property var theme: currentTheme
    property var lang: currentLanguage
            Layout.preferredHeight: 60
            Layout.fillWidth: true
            color: theme.primary.dim_background
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10
                // Danh mục tab
                Repeater {
                    model: [
                        { name: lang.appearance?.theme || "Theme", category: "theme" },
                        { name: lang.appearance?.panel || "Panel", category: "panel" },
                        { name: lang.appearance?.clock || "Clock", category: "clock" },
                        { name: lang.appearance?.fonts || "Fonts", category: "fonts" },
                        { name: lang.appearance?.icons || "Icons", category: "icons" },
                        { name: lang.appearance?.effects || "Effects", category: "effects" },
                        { name: lang.appearance?.layout || "Layout", category: "layout" },
                        { name: lang.appearance?.wallpaper || "Wallpaper", category: "wallpaper" },
                        { name: lang.appearance?.advanced || "Advanced", category: "advanced" }
                    ]

                    delegate: Rectangle {
                        id: tabDelegate
                        Layout.preferredWidth: 100
                        Layout.fillHeight: true
                        radius: 8
                        
                        property bool hovered: false
                        property bool selected: root.currentTab === index

                        color: mouseArea.containsPress ? theme.button.background_select : 
                               hovered ? theme.button.background_select : 
                               selected ? theme.button.background_select : theme.button.background
                        
                        border.color: mouseArea.containsPress ? theme.button.border_select : 
                                     hovered ? theme.normal.blue : 
                                     selected ? theme.button.border_select : theme.button.border
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
                            spacing: 12
                            
                            // Không có icon, chỉ text
                            Text {
                                text: modelData.name
                                color: hovered ? theme.primary.bright_foreground : 
                                       selected ? theme.primary.bright_foreground : theme.primary.foreground
                                font {
                                    family: "ComicShannsMono Nerd Font"
                                    pixelSize: 16
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
                            
                            // Indicator khi selected
                            Rectangle {
                                Layout.preferredWidth: 4
                                Layout.preferredHeight: 20
                                radius: 2
                                color: theme.normal.blue
                                visible: selected
                                opacity: hovered ? 1.0 : 0.8
                                
                                // Hiệu ứng xuất hiện
                                scale: selected ? 1.0 : 0.0
                                Behavior on scale { 
                                    NumberAnimation { 
                                        duration: 300; 
                                        easing.type: Easing.OutBack 
                                    } 
                                }
                                Behavior on opacity { NumberAnimation { duration: 200 } }
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
