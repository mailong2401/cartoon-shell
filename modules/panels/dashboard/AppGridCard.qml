import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import "." as Com

Rectangle {
    id: root

    property var theme: currentTheme

    Layout.preferredWidth: 220
    Layout.preferredHeight: 220
    radius: 28
    color: theme.primary.background
    border.color: theme.button.border
    border.width: 3

    GridLayout {
        anchors.fill: parent
        anchors.margins: 20
        columns: 3
        rows: 3
        columnSpacing: 15
        rowSpacing: 15

        Repeater {
            model: 9
            
            Com.AppIcon { 
                iconSource: configLoader.config.dashboard?.listApp?.[index]?.pathIcon || "" 
                bgColor: theme.button.background 
            }
        }
    }
}
