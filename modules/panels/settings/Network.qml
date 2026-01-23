// components/Settings/NetworkSettings.qml
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
            width: parent.width - 40
            spacing: 20
            
            Text {
                text: "Network Settings"
                color: theme.primary.foreground
                font.pixelSize: 24
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
                Layout.topMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.foreground
            }
            
            // Thông báo phần đã bị xóa
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    
                    Text {
                        text: "Network Settings Content"
                        color: theme.primary.foreground
                        font.pixelSize: 16
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    Text {
                        text: "Network information and controls have been removed."
                        color: theme.primary.dim_foreground
                        font.pixelSize: 12
                        font.family: "ComicShannsMono Nerd Font"
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }
                }
            }
        }
    }
}
