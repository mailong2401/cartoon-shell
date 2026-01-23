import QtQuick
import QtQuick.Layouts

Rectangle {
    id: barListSettings
    property var theme : currentTheme
    property var lang : currentLanguage
    property int currentIndex: 0
    property var listModal
    property var title
    
    signal categoryChanged(int index)

    Layout.preferredWidth: 260
    Layout.fillHeight: true
    color: theme.primary.dim_background
    radius: 12
    border.color: theme.button.border
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Tiêu đề
        Text {
            text: barListSettings.title
            color: theme.primary.foreground
            font {
                family: "ComicShannsMono Nerd Font"
                pixelSize: 26
                bold: true
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 15
            Layout.bottomMargin: 25
        }

        // Danh mục cài đặt
        Repeater {
            model: listModal

            delegate: Rectangle {
                id: categoryDelegate
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                radius: 8
                
                property bool hovered: false
                property bool selected: barListSettings.currentIndex === index

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
                    anchors.margins: 8
                    spacing: 12
                    
                    Image {
                        source: modelData.icon
                        Layout.preferredHeight: 28
                        Layout.preferredWidth: 28
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Text {
                        text: modelData.name
                        color: selected ? theme.primary.bright_foreground : theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 16
                            bold: selected
                        }
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    
                    // Indicator khi selected
                    Rectangle {
                        Layout.preferredWidth: 4
                        Layout.preferredHeight: 20
                        radius: 2
                        color: theme.normal.blue
                        visible: selected
                        
                        // Hiệu ứng xuất hiện
                        scale: selected ? 1.0 : 0.0
                        Behavior on scale { 
                            NumberAnimation { 
                                duration: 300; 
                                easing.type: Easing.OutBack 
                            } 
                        }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        barListSettings.currentIndex = index
                        barListSettings.categoryChanged(index)
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
