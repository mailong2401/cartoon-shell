import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: wtDetailPanel

    property var sizes: currentSizes.wtDetailPanel || {}
    property var theme: currentTheme
    signal closeRequested()

    
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.exclusiveZone: -1

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: closeRequested()
    }

    

    color: "transparent"

    Rectangle {
      implicitWidth: sizes.panelWidth || 500
      implicitHeight: sizes.panelHeight || 500
      anchors {
            top: currentConfig.mainPanelPos === "top" ? parent.top : undefined
            bottom: currentConfig.mainPanelPos === "bottom" ? parent.bottom : undefined
            left: parent.left
        }
        anchors.topMargin: currentConfig.mainPanelPos === "top" ? currentSizes.panelHeight + 10 : 0
        anchors.bottomMargin: currentConfig.mainPanelPos === "bottom" ? currentSizes.panelHeight + 10 : 0
        anchors.leftMargin: sizes.marginLeft

        color: theme.primary.background
        radius: sizes.panelRadius || 8
        border.color: theme.button.border
        border.width: sizes.panelBorderWidth || 3
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
            onClicked: {
                mouse.accepted = true
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.panelMargins || 16
            spacing: sizes.spacing || 16

            Components.WtDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.header?.height || 70
                sizes: wtDetailPanel.sizes
            }

            Components.WtDetailCalendar {
                Layout.alignment: Qt.AlignHCenter
                sizes: wtDetailPanel.sizes
            }
        }
    }
}
