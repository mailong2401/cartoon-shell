import QtQuick
import QtQuick.Layouts
import qs.commons
import qs.components
import qs.services

RowLayout {
  id: root
  Layout.fillWidth: true
  Layout.preferredHeight: ScalerService.s(60)
  property real animationProgress: 0
  spacing: ScalerService.s(24)

  Item { Layout.fillWidth: true }

  // Previous
  Rectangle {
    Layout.preferredWidth: ScalerService.s(48)
    Layout.preferredHeight: ScalerService.s(48)
    radius: ScalerService.s(24)
    color: prevArea.containsMouse ? theme.button.text : theme.button.background
    opacity: root.animationProgress > 0.2 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    IconText {
      anchors.centerIn: parent
      name: "skip_previous"
      size: "large"
      opacity: root.animationProgress > 0.6 ? 1 : 0
    }

    MouseArea {
      id: prevArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: Players.mprisPlayer?.previous()
    }

    Behavior on color { ColorAnimation { duration: 150 } }
  }

  // Play/Pause
  Rectangle {
    Layout.preferredWidth: ScalerService.s(64)
    Layout.preferredHeight: ScalerService.s(64)
    radius: ScalerService.s(32)
    color: playArea.containsMouse ? Qt.alpha(theme.button.text, 0.5) : Qt.alpha(theme.button.background, 0.5)
    opacity: root.animationProgress > 0.3 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    IconText {
      anchors.centerIn: parent
      name: Players.mprisPlayer && Players.mprisPlayer.isPlaying ? "pause" : "play_arrow"
      size: "large"
      opacity: root.animationProgress > 0.7 ? 1 : 0
    }

    MouseArea {
      id: playArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: Players.mprisPlayer?.togglePlaying()
    }

    Behavior on color { ColorAnimation { duration: 150 } }
  }

  // Next
  Rectangle {
    Layout.preferredWidth: ScalerService.s(48)
    Layout.preferredHeight: ScalerService.s(48)
    radius: ScalerService.s(24)
    color: nextArea.containsMouse ? theme.button.text : theme.button.background
    opacity: root.animationProgress > 0.4 ? 1 : 0
    Behavior on opacity {
      NumberAnimation {
        duration: 200
      }
    }

    IconText {
      anchors.centerIn: parent
      name: "skip_next"
      size: "large"
      opacity: root.animationProgress > 0.8 ? 1 : 0
    }

    MouseArea {
      id: nextArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: Players.mprisPlayer?.next()
    }

    Behavior on color { ColorAnimation { duration: 150 } }
  }

  Item { Layout.fillWidth: true }
}
