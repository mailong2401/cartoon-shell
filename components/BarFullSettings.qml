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
            radius: width / 2  // Tạo hình tròn
            color: theme.normal.blue
            
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.leftMargin: 5  // Khoảng cách giữa 2 hình tròn

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
            radius: width / 2  // Tạo hình tròn
            color: theme.normal.red
            
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.leftMargin: 10  // Khoảng cách từ lề trái
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
