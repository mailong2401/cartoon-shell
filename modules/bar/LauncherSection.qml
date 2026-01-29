import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Effects
import Quickshell.Io

Rectangle {
    id: root
    width: 200
    height: 50
    color: theme.primary.background
    radius: 10
    border.color: theme.button.border
    border.width: 3
    property var theme : currentTheme
    RowLayout {
        anchors.centerIn: parent
        spacing: 15
        Image {
            source: "../../assets/launcher/dashboard.png"
            Layout.preferredWidth:  32
            Layout.preferredHeight:  32
            fillMode: Image.PreserveAspectFit
            smooth: true

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    panelManager.togglePanel("launcher")
                }
            }
        }
    }
}
