pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.commons

Singleton {
  id: root

  property bool ready: false


  readonly property alias appearance: adapter.appearance
  readonly property alias wallpaper: adapter.wallpaper
  readonly property alias general: adapter.general


  signal settingsLoaded
  signal settingsSaved

  Component.onCompleted: {
    settingsFileView.adapter = adapter;
  }

  Timer {
    id: saveTimer
    running: false
    interval: 1000
    onTriggered: {
      root.saveImmediate();
    }
  }

  function saveImmediate() {
    settingsFileView.writeAdapter();
    root.ready = true;
    root.settingsSaved();
  }

  FileView {
    id: settingsFileView
    path: Directories.shellConfigSettingsPath
    printErrors: false
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: saveTimer.start()
    onPathChanged: {
      if (path !== undefined) {
        reload();
      }
    }
    onLoaded: function () {
      if (!root.ready) {
        root.ready = true;
        root.settingsLoaded();
      }
    }
    onLoadFailed: function (error) {
      if (error === FileViewError.FileNotFound) {
        writeAdapter();
      }
    }
  }

  JsonAdapter {
    id: adapter

    property Wallpaper wallpaper: Wallpaper {}
    property Appearance appearance: Appearance {}
    property General general: General {}
  }

  component Appearance: JsonObject {
    property string theme: "matugen"
    property string mode: "dark"
    property string fonts: ""
    property int radius: 16
  }

  component General: JsonObject {
    property string lang: "vi"
  }

  component Wallpaper: JsonObject {
    property bool enabled: true
    property bool overviewEnabled: true
    property string directory: Directories.defaultWallpaperDir
    property bool enableMultiMonitorDirectories: false
    property bool recursiveSearch: false
    property bool setWallpaperOnAllMonitors: true
    property string defaultWallpaper: ""
    property string fillMode: "crop"
    property color fillColor: "#000000"
    property list<var> monitors: []
    property int transitionDuration: 500
    property real transitionEdgeSmoothness: 0.05
  }
}
