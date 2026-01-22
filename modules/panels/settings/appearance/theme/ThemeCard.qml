// components/Settings/ThemeCard.qml
import QtQuick

Rectangle {
    id: themeCard
    property string type: "light" // "light" or "dark"
    property bool isSelected: false
    property string label: ""
    property var theme
    property alias mouseArea: clickArea
    
    signal clicked
    
    width: 100
    height: 80
    radius: 12
    color: type === "light" ? "#f5eee6" : "#24273a"
    border.color: isSelected ? theme.normal.blue : theme.button.border
    border.width: isSelected ? 3 : 2

    Column {
        anchors.centerIn: parent
        spacing: 6

        Rectangle {
            width: 60
            height: 24
            radius: 8
            color: type === "light" ? "#2b2530" : "#cad3f5"
        }

        Rectangle {
            width: 60
            height: 10
            radius: 3
            color: type === "light" ? "#b0a89e" : "#494d64"
        }
    }

    MouseArea {
        id: clickArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: themeCard.clicked()
    }

    Text {
        text: label
        color: type === "light" ? "#2b2530" : "#cad3f5"
        font {
            family: "ComicShannsMono Nerd Font"
            pixelSize: 12
            bold: true
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
    }

    // Checkmark for selected theme
    Rectangle {
        visible: isSelected
        width: 20
        height: 20
        radius: 10
        color: theme.normal.blue
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5

        Text {
            text: "✓"
            color: theme.primary.background
            font.pixelSize: 12
            font.bold: true
            anchors.centerIn: parent
        }
    }
}
