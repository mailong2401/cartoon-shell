import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "clockTime" as Com
import qs.components

Item {
  id: root
  property var theme: currentTheme
  property var lang: currentLanguage
  property var panelConfig
  
  ScrollView {
    id: scrollView
    anchors.fill: parent
    clip: true
    
    ScrollBar.vertical.policy: ScrollBar.AsNeeded
    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
    
    contentWidth: contentLayout.width
    contentHeight: contentLayout.height
    
    ColumnLayout {
      id: contentLayout
      width: scrollView.availableWidth
      spacing: 20
            anchors.margins: 20

      HeaderSettings{
        name: "Clock Time"
      }

      Rectangle {
        Layout.fillWidth: true
        height: 1
        color: theme.primary.foreground
        opacity: 0.3
      }

      // Nội dung Clock ở đây
      Text {
        text: "Clock settings content"
        color: theme.primary.foreground
        Layout.alignment: Qt.AlignLeft
      }
      
      Com.ClockPanelToggle {
        Layout.fillWidth: true
        panelConfig: root.panelConfig
      }
      
      Com.ClockPositionSelector {
        Layout.fillWidth: true
        panelConfig: root.panelConfig
      }
      
      Item {
        // Spacer để đảm bảo nội dung không bị che
        Layout.fillHeight: true
      }
    }
  }
}
