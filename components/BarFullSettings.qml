import QtQuick
import QtQuick.Layouts

Item {

    property var theme: currentTheme
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        
        Item {
            Layout.fillWidth: true
        }
        
        Rectangle {
            width: 25
            height: 25
            radius: 5
            color: theme.primary.dim_background
            border{
              color: theme.button.border
              width: 2
            }

            Text {
        text: "-"
        font.pixelSize: 16
        anchors.centerIn: parent
        color: theme.primary.foreground
    }
            
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("fullsetting")
                }
            }
        }
        
        Rectangle {
            width: 25
            height: 25
            radius: 5
            color: theme.primary.dim_background
            border{
              color: theme.button.border
              width: 2
            }

            Text {
        text: "x"
        font.pixelSize: 16
        anchors.centerIn: parent
        color: theme.primary.foreground
    }
            
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("launcher")
                }
            }
        }
    }
}
