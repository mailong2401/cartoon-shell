import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar

PanelWindow {
  id: panel
  implicitHeight: 50
  color: "transparent"

  anchors {
      left: true
      right: true
      top: currentConfig.mainPanelPos === "top"
      bottom: currentConfig.mainPanelPos === "bottom"
  }

  margins {
      top: currentConfig.mainPanelPos === "top" ? 10 : 0
      left: 10
      right: 10
      bottom: currentConfig.mainPanelPos === "bottom" ? 10 : 0
  }

  RowLayout {
      anchors.fill: parent
       LauncherSection{
          Layout.preferredWidth: 60
          Layout.fillHeight: true
      }
      Item{Layout.fillWidth: true}
      WorkspaceSection {
          visible: true
          Layout.preferredWidth: 380
          Layout.fillHeight: true
      }
      Item{Layout.fillWidth: true}
      MediaSection {
          Layout.preferredWidth: 340
          Layout.fillHeight: true
      }
      Item{Layout.fillWidth: true}
      InfoSection{
          Layout.preferredWidth: 400
          Layout.fillHeight: true
      }
      Item{Layout.fillWidth: true}
      SystemStatsSection {
          Layout.preferredWidth: 200
          Layout.fillHeight: true
      }
      Item{Layout.fillWidth: true}
      StatusTraySection {
          Layout.preferredWidth: 430
          Layout.fillHeight: true
      }
  }
}
