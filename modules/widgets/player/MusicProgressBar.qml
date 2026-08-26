import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

ColumnLayout {
  Layout.fillWidth: true
  spacing: ScalerService.s(6)
  property real animationProgress: 0

  // Progress bar
  Rectangle {
    id: parent_progress_bar
    Layout.fillWidth: true
    Layout.preferredHeight: ScalerService.s(4)
    radius: ScalerService.s(2)
    color: theme.primary.dim_background
    opacity: root.animationProgress > 0.5 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    Rectangle {
      id: progress_bar
      width: root.animationProgress > 1.2 ? parent.width * Players.getProgress() : 0
      height: parent.height
      radius: ScalerService.s(2)
      color: theme.button.text
      opacity: root.animationProgress > 0.9 ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: 200
        }
      }
      Behavior on width {
        NumberAnimation {
          duration: 200
        }
      }
    }
  }

  // Time labels
  RowLayout {
    Layout.fillWidth: true
    spacing: ScalerService.s(0)

    CustomText{
      id: music_pos
      name: Players.formatTime(Players.mprisPlayer?.position)
      size: "xs"
      Layout.alignment: Qt.AlignLeft
      textColor: theme.primary.dim_foreground
      opacity: root.animationProgress > 1 ? 1 : 0

    }

    Item {
      Layout.fillWidth: true
    }
    CustomText{
      name: Players.formatTime(Players.mprisPlayer?.length)
      size: "xs"
      Layout.alignment: Qt.AlignRight

      textColor: theme.primary.dim_foreground
      opacity: root.animationProgress > 1.1 ? 1 : 0
    }
  }
  Timer {
    interval: 1000   // 1 giây
    running: true
    repeat: true
    onTriggered: {
      music_pos.name = Players.formatTime(Players.mprisPlayer?.position)
      progress_bar.width = parent_progress_bar.width * Players.getProgress()
    }
  }
}
