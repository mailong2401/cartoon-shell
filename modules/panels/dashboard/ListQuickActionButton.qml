import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

import "." as Com

ColumnLayout {
    Layout.preferredWidth: 90
    spacing: 15
    property var theme: currentTheme
    property var sizes: currentSizes
    RowLayout {
      spacing: 15
      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 110
        radius: 28
        color: mouseAreaLogout.containsMouse ? theme.button.background_select : theme.primary.background
            border.color: mouseAreaLogout.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3

        Image {
            source: "../../../assets/system/sys-exit.png"
            anchors.centerIn: parent
            width: sizes.iconSize?.xlarge || 50
            height: sizes.iconSize?.xlarge || 50
            fillMode: Image.PreserveAspectFit
            smooth: true
            rotation: mouseAreaLogout.containsMouse ? -5 : 0
            Behavior on rotation { NumberAnimation { duration: 200 } }
        }

        MouseArea {
                id: mouseAreaLogout
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                }
            }
      }


      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 110
        radius: 28
        color: mouseAreaSleep.containsMouse ? theme.button.background_select : theme.primary.background
            border.color: mouseAreaSleep.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3

        Image {
            source: "../../../assets/system/sys-sleep.png"
            anchors.centerIn: parent
            width: sizes.iconSize?.xlarge || 50
            height: sizes.iconSize?.xlarge || 50
            fillMode: Image.PreserveAspectFit
            smooth: true
            rotation: mouseAreaSleep.containsMouse ? 5 : 0
                    Behavior on rotation { NumberAnimation { duration: 200 } }
        }

        MouseArea {
                id: mouseAreaSleep
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                }
            }
      }
    }
    RowLayout {
        spacing: 15
        Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 110
        radius: 28
        color: mouseAreaRestart.containsMouse ? theme.button.background_select : theme.primary.background
            border.color: mouseAreaRestart.containsPress ? theme.button.border_select : theme.button.border
            border.width: 3

        Image {
            source: "../../../assets/system/sys-reboot.png"
            anchors.centerIn: parent
            width: sizes.iconSize?.xlarge || 50
            height: sizes.iconSize?.xlarge || 50
            fillMode: Image.PreserveAspectFit
            smooth: true
            rotation: mouseAreaRestart.containsMouse ? 180 : 0
            Behavior on rotation { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic } }
        }

        MouseArea {
                id: mouseAreaRestart
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                }
            }
      }
        Com.QuickActionButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            icon: "../../../assets/system/shutdown.png"
            iconColor: theme.normal.yellow
        }
    }
}
