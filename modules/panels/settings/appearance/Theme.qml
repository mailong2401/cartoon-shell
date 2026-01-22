import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./theme" as Com
import qs.services
import qs.components

Item {
    id: root
    property var theme: currentTheme
    property var lang: currentLanguage
    property var panelConfig

    Matugen {
        id: matugenHandler
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        clip: true
        
        // Cấu hình scrollbar
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.interactive: true
        
        // Content area
        contentWidth: contentLayout.width
        contentHeight: contentLayout.height
        
        // Nền cho scrollview
        background: Rectangle {
            color: "transparent"
        }

        ColumnLayout {
            id: contentLayout
            width: scrollView.availableWidth
            spacing: 25

            // Tiêu đề chính
            HeaderSettings{
              name: "Theme"
            }
            

            // Đường phân cách
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.foreground
                opacity: 0.2
                Layout.bottomMargin: 5
            }

            // Container chính cho nội dung
            Rectangle {
                id: contentContainer
                Layout.fillWidth: true
                color: "transparent"
                
                ColumnLayout {
                    width: parent.width
                    spacing: 25
                    
                    // Phần chọn theme
                    Com.ThemeSelection {
                        id: themeSelection
                        width: parent.width
                        panelConfig: root.panelConfig
                        matugenHandler: matugenHandler
                        Layout.fillWidth: true
                    }

                    // Thêm phần cài đặt theme khác nếu cần
                    // Ví dụ: chế độ tối/sáng tự động
                    ColumnLayout {
                        width: parent.width
                        spacing: 15
                        visible: false // Tạm ẩn
                        
                        Text {
                            text: "Tùy chọn nâng cao"
                            color: theme.primary.foreground
                            font {
                                family: "ComicShannsMono Nerd Font"
                                pixelSize: 18
                                bold: true
                            }
                            Layout.alignment: Qt.AlignLeft
                        }
                        
                        // Các tùy chọn nâng cao có thể thêm ở đây
                    }
                }
            }

            // Spacer để đảm bảo nội dung không bị che ở dưới
            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 20
            }
        }
    }

    // Tùy chọn: Hiển thị thanh scrollbar custom nếu muốn
    Component {
        id: customScrollBar
        
        Rectangle {
            id: scrollBar
            width: 8
            radius: 4
            color: theme.normal.blue
            opacity: 0.5
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
            
            states: State {
                name: "hovered"
                when: scrollBar.MouseArea.containsMouse
                PropertyChanges {
                    target: scrollBar
                    opacity: 0.8
                    width: 10
                }
            }
        }
    }

    // Debug: Hiển thị kích thước scrollview (có thể xóa)
    Rectangle {
        visible: false // Đặt true để debug
        anchors.fill: scrollView
        color: "transparent"
        border.color: "red"
        border.width: 1
        
        Text {
            anchors.centerIn: parent
            text: `SV: ${scrollView.width}x${scrollView.height}\nContent: ${scrollView.contentWidth}x${scrollView.contentHeight}`
            color: "red"
            font.pixelSize: 10
        }
    }
}
