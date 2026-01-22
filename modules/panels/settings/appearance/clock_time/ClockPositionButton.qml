// components/Settings/ClockPositionButton.qml
import QtQuick

Rectangle {
    id: clockPositionButton
    property string position: ""
    property bool isSelected: false
    property var theme
    property var anchorConfig: ({})
    
    signal clicked
    
    width: 60
    height: 60
    radius: 12
    color: isSelected ? theme.normal.blue : (mouseArea.containsMouse ? theme.button.background_select : theme.button.background)
    border.color: isSelected ? theme.normal.blue : (mouseArea.containsPress ? theme.button.border_select : theme.button.border)
    border.width: 3

    Rectangle {
        width: 25
        height: 15
        radius: 6
        color: isSelected ? theme.primary.dim_foreground : theme.normal.blue

        anchors.top: anchorConfig.top ? parent.top : undefined
        anchors.bottom: anchorConfig.bottom ? parent.bottom : undefined
        anchors.left: anchorConfig.left ? parent.left : undefined
        anchors.right: anchorConfig.right ? parent.right : undefined
        anchors.horizontalCenter: anchorConfig.hCenter ? parent.horizontalCenter : undefined
        anchors.verticalCenter: anchorConfig.vCenter ? parent.verticalCenter : undefined

        anchors.topMargin: anchorConfig.top ? 10 : 0
        anchors.bottomMargin: anchorConfig.bottom ? 10 : 0
        anchors.leftMargin: anchorConfig.left ? 10 : 0
        anchors.rightMargin: anchorConfig.right ? 10 : 0
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: clockPositionButton.clicked()
    }
}
