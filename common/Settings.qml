pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
  id: root

  property bool ready: false

  readonly property alias appearance: adapter.appearance
  readonly property alias bar: adapter.bar
  readonly property alias delay: adapter.delay
  readonly property alias brightness: adapter.brightness
  readonly property alias wallpaper: adapter.wallpaper
  readonly property alias network: adapter.network
  readonly property alias audio: adapter.audio
  readonly property alias launcher: adapter.launcher
  readonly property alias general: adapter.general
  readonly property alias session: adapter.session
  readonly property alias lock: adapter.lock
  readonly property alias notifications: adapter.notifications
  readonly property alias systemMonitor: adapter.systemMonitor

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

    property General general: General {}
    property Appearance appearance: Appearance {}
    property Bar bar: Bar {}
    property Delay delay: Delay {}
    property Brightness brightness: Brightness {}
    property Wallpaper wallpaper: Wallpaper {}
    property Network network: Network {}
    property Audio audio: Audio {}
    property Launcher launcher: Launcher {}
    property Session session: Session {}
    property Lock lock: Lock {}
    property Notifications notifications: Notifications {}
    property SystemMonitor systemMonitor: SystemMonitor {}
  }

  component Bar: JsonObject {
    property bool persistent: false
    property bool showOnHover: false
    property list<string> monitors: []
    property Workspace workspace: Workspace {}
    property Tray tray: Tray {}
    property JsonObject widgets: JsonObject {
      property list<var> left: [
        {
          id: "OsIcon"
        },
        {
          id: "Workspace"
        },
        {
          id: "Media"
        }
      ]
      property list<var> center: [
        {
          id: "Clock"
        }
      ]
      property list<var> right: [
        {
          id: "Tray"
        },
        {
          id: "Volume"
        },
        {
          id: "Brightness"
        },
        {
          id: "Network"
        },
        {
          id: "Battery"
        }
      ]
    }
  }

  component Appearance: JsonObject {
    property int thickness: 6
    property int cornerRadius: 8
    property Theme theme: Theme {}
    property FontStuff font: FontStuff {}
  }

  component Theme: JsonObject {
    property string mode: "light"
    property string light: "Ling Light"
    property string dark: "Ling Dark"
    property bool dynamic: true
    property string matugenType: "scheme-tonal-spot"
  }

  component FontStuff: JsonObject {
    property string mono: "ComicShannsMono Nerd Font"
  }

  component Delay: JsonObject {
    property int pill: 200
  }

  component Brightness: JsonObject {
    property real brightnessStep: 5.0
    property bool enforceMinimum: true
    property bool enableDdcSupport: false
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

  component Network: JsonObject {
    property bool wifiEnabled: true
    property bool bluetoothRssiPollingEnabled: false
    property int bluetoothRssiPollIntervalMs: 10000
    property bool bluetoothHideUnnamedDevices: false
    property string wifiDetailsViewMode: "grid"
    property string networkPanelView: "wifi"
  }

  component Audio: JsonObject {
    property real volumeStep: 5.0
    property bool volumeOverdrive: false
    property int cavaFrameRate: 30
    property string visualizerType: "linear"
    property list<string> mprisBlacklist: []
    property string preferredPlayer: ""
  }

  component Workspace: JsonObject {
    property int shown: 5
    property bool activeIndicator: true
    property bool occupiedBg: false
    property bool showWindows: true
    property bool showWindowsOnSpecialWorkspaces: showWindows
    property bool activeTrail: false
    property bool perMonitorWorkspaces: true
    property string label: "  "
    property string occupiedLabel: "󰮯"
    property string activeLabel: "󰮯"
    property string capitalisation: "preserve"
  }

  component Tray: JsonObject {
    property list<string> blacklist: []
    property list<string> favorites: []
    property bool colorize: false
  }

  component Launcher: JsonObject {
    property int maxShown: 7
    property string specialPrefix: "@"
    property string actionPrefix: ">"
    property list<string> hiddenApps: []
    property int maxWallpapers: 5
  }

  component General: JsonObject {
    property string avatarImage: Directories.defaultAvatarPath
  }

  component Session: JsonObject {
    property string gif: "root:/assets/jingliu.gif"
    property int dragThreshold: 30
    property bool vimKeybinds: false
  }

  component Lock: JsonObject {
    property bool recolourLogo: false
    property bool enableFprint: true
    property int maxFprintTries: 3
  }

  component Notifications: JsonObject {
    property bool enabled: true
    property bool expire: true
    property int defaultExpireTimeout: 5000
    property real clearThreshold: 0.3
    property int expandThreshold: 20
    property bool actionOnClick: false
    property int groupPreviewNum: 3
  }

  component SystemMonitor: JsonObject {
    property int cpuWarningThreshold: 80
    property int cpuCriticalThreshold: 90
    property int tempWarningThreshold: 80
    property int tempCriticalThreshold: 90
    property int gpuWarningThreshold: 80
    property int gpuCriticalThreshold: 90
    property int memWarningThreshold: 80
    property int memCriticalThreshold: 90
    property int swapWarningThreshold: 80
    property int swapCriticalThreshold: 90
    property int diskWarningThreshold: 80
    property int diskCriticalThreshold: 90
    property int cpuPollingInterval: 3000
    property int tempPollingInterval: 3000
    property int gpuPollingInterval: 3000
    property bool enableDgpuMonitoring: false
    property int memPollingInterval: 3000
    property int diskPollingInterval: 30000
    property int networkPollingInterval: 3000
    property int loadAvgPollingInterval: 3000
    property bool useCustomColors: false
    property string warningColor: ""
    property string criticalColor: ""
    property string externalMonitor: "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor"
  }
}
