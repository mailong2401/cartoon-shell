pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.commons
import qs.widgets
import qs.services

Item {
  id: root
  required property ShellScreen screen
  required property Item bar
  required property Component contentComponent

  property bool shouldBeActive: false
  property var pendingButton: null
  property var buttonItem: null

  property int contentHeight: 0
  readonly property real maxHeight: screen.height - Settings.appearance.thickness * 2 - Style.appearance.spacing.small
  readonly property real padding: Style.appearance.padding.normal
  readonly property real spacing: Style.appearance.spacing.small

  visible: height > 0
  implicitWidth: content.implicitWidth
  implicitHeight: 0
  clip: true

  signal opened

  function toggle(button) {
    shouldBeActive ? close() : open(button);
  }

  function close() {
    shouldBeActive = false;
    pendingButton = null;
    buttonItem = null;
    VisibilityService.closedPanel(root);
  }

  function open(button) {
    if (!content.item) {
      pendingButton = button;
      content.active = true;
      return;
    }
    performOpen(button);
  }

  function performOpen(button) {
    pendingButton = null;
    buttonItem = button;

    if (button) {
      const p = button.mapToItem(null, 0, 0);
      const center = p.x + button.width / 2;
      const off = center - content.implicitWidth / 2 - Settings.appearance.thickness;
      const diff = root.screen.width - Math.floor(off + content.implicitWidth);
      root.x = diff < 0 ? off + diff - Settings.appearance.thickness * 2 : Math.max(off, 0);
    }

    root.contentHeight = Math.min(root.maxHeight, content.implicitHeight);
    shouldBeActive = true;
    VisibilityService.willOpenPanel(root);
    opened();
  }

  onShouldBeActiveChanged: {
    if (shouldBeActive) {
      timer.stop();
      hideAnim.stop();
      root.contentHeight = Math.min(root.maxHeight, content.implicitHeight);
      content.active = true;
      content.visible = true;
      showAnim.start();
    } else {
      showAnim.stop();
      hideAnim.start();
    }
  }

  SequentialAnimation {
    id: showAnim
    IAnim {
      target: root
      property: "implicitHeight"
      to: root.contentHeight
      duration: Style.appearance.anim.durations.expressiveDefaultSpatial
      easing.bezierCurve: Style.appearance.anim.curves.expressiveDefaultSpatial
    }
    ScriptAction {
      script: root.implicitHeight = Qt.binding(() => Math.min(root.maxHeight, content.implicitHeight))
    }
  }

  SequentialAnimation {
    id: hideAnim
    ScriptAction {
      script: root.implicitHeight = root.implicitHeight
    }
    IAnim {
      target: root
      property: "implicitHeight"
      to: 0
      duration: Style.appearance.anim.durations.normal
      easing.bezierCurve: Style.appearance.anim.curves.emphasized
    }
    ScriptAction {
      script: {
        content.visible = false;
        content.active = false;
      }
    }
  }

  Timer {
    id: timer
    interval: 20
    repeat: false
    onTriggered: {
      root.contentHeight = Math.min(root.maxHeight, content.implicitHeight);
      content.active = root.shouldBeActive || root.visible;
      content.visible = true;
      if (showAnim.running) {
        showAnim.stop();
        showAnim.start();
      }
      if (root.pendingButton)
        root.performOpen(root.pendingButton);
    }
  }

  Shortcut {
    sequence: "Escape"
    enabled: root.visible
    onActivated: root.close()
  }

  Loader {
    id: content
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
    active: false
    asynchronous: true
    sourceComponent: root.contentComponent

    onLoaded: {
      Qt.callLater(() => timer.start());
    }
  }
}
