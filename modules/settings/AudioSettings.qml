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
            Text {
                text: "Audio Settings"
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
        }
    }
}
