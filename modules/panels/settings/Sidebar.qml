import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sidebarSettings
    property var theme : currentTheme
    property var lang : currentLanguage
    property int currentIndex: 0
    property bool anyItemHovered: false
    property bool isExpanded: !panelManager.fullsetting ? true : anyItemHovered
    
    signal categoryChanged(int index)
    signal backRequested()

    Layout.preferredWidth: isExpanded ? 200 : 90
    Layout.fillHeight: true
    color: theme.primary.dim_background
    radius: 12
    border.color: theme.button.border
    border.width: 2

    // Behavior cho animation width
    Behavior on Layout.preferredWidth {
        NumberAnimation { 
            duration: 250
            easing.type: Easing.OutCubic 
        }
    }

    // MouseArea cho toàn bộ sidebar
    MouseArea {
        id: sidebarMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton // Chỉ theo dõi hover, không xử lý click
        propagateComposedEvents: true // Cho phép sự kiện truyền xuống các MouseArea con
        
        onEntered: {
            sidebarSettings.anyItemHovered = true
        }
        
        onExited: {
            sidebarSettings.anyItemHovered = false
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: isExpanded ? 12 : 6
        spacing: 10

        // Tiêu đề - chỉ hiển thị khi expanded
        Text {
            text: lang.settings.title
            color: theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: isExpanded ? 26 : 0
                bold: true
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: isExpanded ? 15 : 8
            Layout.bottomMargin: isExpanded ? 25 : 8
            opacity: isExpanded ? 1 : 0
            visible: isExpanded
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        // Danh mục cài đặt
        Repeater {
            id: categoryRepeater
            model: [
                { name: lang.settings.general, icon: "../../../assets/settings/home.png", category: "general" },
                { name: lang.settings.appearance, icon: "../../../assets/settings/paint-brush.png", category: "appearance" },
                { name: lang.settings.wallpapers, icon: "../../../assets/settings/Wallpaper.png", category: "wallpaper" },
                { name: "dashboard" , icon: "../../../assets/settings/lockscreen.png", category: "dashboard" },
                { name: lang.settings.network, icon: "../../../assets/settings/network.png", category: "network" },
                { name: lang.settings.audio, icon: "../../../assets/settings/volume.png", category: "audio" },
                { name: lang.settings.performance, icon: "../../../assets/settings/speedometer.png", category: "performance" },
                { name: lang.settings.shortcuts, icon: "../../../assets/settings/keyboard.png", category: "shortcuts" },
                { name: lang.settings.system, icon: "../../../assets/settings/mark.png", category: "system" }
            ]

            delegate: Rectangle {
                id: categoryDelegate
                Layout.fillWidth: true
                Layout.preferredHeight: isExpanded ? 50 : 40
                radius: 8
                
                property bool hovered: false
                property bool selected: sidebarSettings.currentIndex === index

                color: mouseArea.containsPress ? theme.button.background_select : 
                       selected ? theme.button.background_select : theme.button.background
                
                border.color: mouseArea.containsPress ? theme.button.border_select : 
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
                    anchors.margins: isExpanded ? 8 : 4
                    spacing: isExpanded ? 12 : 0
                    
                    Image {
                        source: modelData.icon
                        Layout.preferredHeight: isExpanded ? 28 : 24
                        Layout.preferredWidth: isExpanded ? 28 : 24
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        Layout.alignment: Qt.AlignHCenter
                        
                        // Hiệu ứng xoay icon khi hover
                        Behavior on rotation { 
                            NumberAnimation { 
                                duration: 300; 
                                easing.type: Easing.OutBack 
                            } 
                        }
                        
                        // Hiệu ứng scale icon khi hover
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 200; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                    }

                    Text {
                        text: modelData.name
                        visible: isExpanded
                        opacity: isExpanded ? 1 : 0
                        color: selected ? theme.primary.bright_foreground : theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: isExpanded ? 16 : 0
                            bold: selected
                        }
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        
                        // Hiệu ứng scale text khi hover
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 200; 
                                easing.type: Easing.OutCubic 
                            } 
                        }
                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }
                    
                    // Indicator khi selected - chỉ hiển thị khi expanded
                    Rectangle {
                        Layout.preferredWidth: 4
                        Layout.preferredHeight: isExpanded ? 20 : 0
                        radius: 2
                        color: theme.normal.blue
                        visible: selected && isExpanded
                        
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
                    cursorShape: Qt.PointingHandCursor
                    propagateComposedEvents: true

                    onClicked: {
                        sidebarSettings.currentIndex = index
                        sidebarSettings.categoryChanged(index)
                    }

                    onEntered: {
                        categoryDelegate.hovered = true
                    }
                    
                    onExited: {
                        categoryDelegate.hovered = false
                    }
                }
            }
        }

        Item { Layout.fillHeight: true } // Spacer
    }
}
