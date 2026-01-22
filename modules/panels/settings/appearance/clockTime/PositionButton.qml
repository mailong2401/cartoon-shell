// components/Settings/PositionButton.qml
import QtQuick

Rectangle {
    id: positionButton
    property string label: ""
    property string position: ""
    property bool isSelected: false
    property var theme: currentTheme
    
    signal clicked
    
    width: 80
    height: 40
    radius: 8
    color: isSelected ? theme.normal.blue : (mouseArea.containsMouse ? theme.button.background_select : theme.button.background)
    border.color: isSelected ? theme.normal.blue : (mouseArea.containsPress ? theme.button.border_select : theme.button.border)
    border.width: 2

    Text {
        text: label
        color: isSelected ? theme.primary.background : theme.primary.foreground
        font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 14
            bold: isSelected
        }
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: positionButton.clicked()
    }
}
