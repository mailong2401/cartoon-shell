// components/Settings/AudioSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var theme : currentTheme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 20
            
            // Tiêu đề
             RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                // Button Nâng cao ở góc trái
                Button {
                    id: advancedButton
                    text: "Nâng cao"
                    font.family: "ComicShannsMono Nerd Font"
                    font.pixelSize: 14
                    
                    background: Rectangle {
                        color: advancedButton.hovered ? theme.button.hover : theme.button.background
                        border.color: theme.button.border
                        border.width: 1
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: advancedButton.text
                        font: advancedButton.font
                        color: theme.button.foreground
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        panelManager.togglePanel("fullsetting")
                        // Thêm xử lý khi click vào đây
                    }
                }
                
                Item {
                    Layout.fillWidth: true
                }
                
                // Tiêu đề (được đẩy sang bên phải)
                Text {
                    text: "Audio Settings"
                    color: theme.primary.foreground
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.foreground
            }
        }
    }
}
