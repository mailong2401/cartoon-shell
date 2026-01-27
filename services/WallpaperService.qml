pragma Singleton

import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import qs.common
import qs.utils

Singleton {
  id: root

  readonly property ListModel fillModeModel: ListModel {}
  readonly property string defaultDirectory: Settings.wallpaper.directory

  readonly property ListModel transitionsModel: ListModel {}

  property var wallpaperLists: ({})
  property int scanningCount: 0
  readonly property bool scanning: (scanningCount > 0)
  property var currentWallpapers: ({})
  property bool isInitialized: false

  signal wallpaperChanged(string screenName, string path)
  signal wallpaperDirectoryChanged(string screenName, string directory)
  signal wallpaperListChanged(string screenName, int count)

  Connections {
    target: Settings.wallpaper

    function onDirectoryChanged() {
      root.refreshWallpapersList();
      if (!Settings.wallpaper.enableMultiMonitorDirectories) {
        for (let i = 0; i < Quickshell.screens.length; i++) {
          root.wallpaperDirectoryChanged(Quickshell.screens[i].name, root.defaultDirectory);
        }
      } else {
        for (let i = 0; i < Quickshell.screens.length; i++) {
          const screenName = Quickshell.screens[i].name;
          const monitor = root.getMonitorConfig(screenName);
          if (!monitor || !monitor.directory) {
            root.wallpaperDirectoryChanged(screenName, root.defaultDirectory);
          }
        }
      }
    }

    function onEnableMultiMonitorDirectoriesChanged() {
      root.refreshWallpapersList();
      for (let i = 0; i < Quickshell.screens.length; i++) {
        var screenName = Quickshell.screens[i].name;
        root.wallpaperDirectoryChanged(screenName, root.getMonitorDirectory(screenName));
      }
    }

    function onRecursiveSearchChanged() {
      root.refreshWallpapersList();
    }
  }

  function init() {
    currentWallpapers = ({});
    console.log("load wallpaper")
    const monitors = Settings.wallpaper.monitors || [];
    for (let i = 0; i < monitors.length; i++) {
      if (monitors[i].name && monitors[i].wallpaper) {
        currentWallpapers[monitors[i].name] = monitors[i].wallpaper;
      }
    }

    isInitialized = true;
    Qt.callLater(refreshWallpapersList);
  }

  function getFillModeUniform() {
    for (let i = 0; i < fillModeModel.count; i++) {
      const mode = fillModeModel.get(i);
      if (mode.key === Settings.wallpaper.fillMode) {
        return mode.uniform;
      }
    }
    return 1.0;
  }

  function getMonitorConfig(screenName) {
    var monitors = Settings.wallpaper.monitors;
    if (monitors !== undefined) {
      for (let i = 0; i < monitors.length; i++) {
        if (monitors[i].name === screenName) {
          return monitors[i];
        }
      }
    }
  }

  function getMonitorDirectory(screenName) {
    if (!Settings.wallpaper.enableMultiMonitorDirectories) {
      return root.defaultDirectory;
    }

    var monitor = getMonitorConfig(screenName);
    if (monitor && monitor.directory !== undefined) {
      return FileUtils.trimFileProtocol(monitor.directory);
    }

    return root.defaultDirectory;
  }

  function setMonitorDirectory(screenName, directory) {
    var monitors = Settings.wallpaper.monitors || [];
    var found = false;

    var newMonitors = monitors.map(function (monitor) {
      if (monitor.name === screenName) {
        found = true;
        return {
          "name": screenName,
          "directory": directory,
          "wallpaper": monitor.wallpaper || ""
        };
      }
      return monitor;
    });

    if (!found) {
      newMonitors.push({
        "name": screenName,
        "directory": directory,
        "wallpaper": ""
      });
    }

    Settings.wallpaper.monitors = newMonitors.slice();
    root.wallpaperDirectoryChanged(screenName, FileUtils.trimFileProtocol(directory));
  }

  function getWallpaper(screenName) {
    return currentWallpapers[screenName] || Settings.wallpaper.defaultWallpaper;
  }

  function changeWallpaper(path, screenName) {
    if (screenName !== undefined) {
      _setWallpaper(screenName, path);
    } else {
      for (let i = 0; i < Quickshell.screens.length; i++) {
        _setWallpaper(Quickshell.screens[i].name, path);
      }
    }
  }

  function _setWallpaper(screenName, path) {
    if (!path)
      return;
    var oldPath = currentWallpapers[screenName] || "";
    if (oldPath === path)
      return;
    currentWallpapers[screenName] = path;

    var monitors = Settings.wallpaper.monitors || [];
    var found = false;

    var newMonitors = monitors.map(function (monitor) {
      if (monitor.name === screenName) {
        found = true;
        return {
          "name": screenName,
          "directory": FileUtils.trimFileProtocol(monitor.directory) || getMonitorDirectory(screenName),
          "wallpaper": path
        };
      }
      return monitor;
    });

    if (!found) {
      newMonitors.push({
        "name": screenName,
        "directory": getMonitorDirectory(screenName),
        "wallpaper": path
      });
    }

    Settings.wallpaper.monitors = newMonitors.slice();

    root.wallpaperChanged(screenName, path);
  }

  function restartRandomWallpaperTimer() {
    if (Settings.wallpaper.isRandom) {
      randomWallpaperTimer.restart();
    }
  }

  function getWallpapersList(screenName) {
    if (screenName && wallpaperLists[screenName]) {
      return wallpaperLists[screenName];
    }
    return [];
  }

  function refreshWallpapersList() {
    scanningCount = 0;

    if (Settings.wallpaper.recursiveSearch) {
      for (let i = 0; i < Quickshell.screens.length; i++) {
        var screenName = Quickshell.screens[i].name;
        var directory = getMonitorDirectory(screenName);
        scanDirectoryRecursive(screenName, directory);
      }
    } else {
      // Trigger wallpaperDirectoryChanged để force recreate models
      for (let i = 0; i < Quickshell.screens.length; i++) {
        var screenName = Quickshell.screens[i].name;
        var directory = getMonitorDirectory(screenName);
        root.wallpaperDirectoryChanged(screenName, directory);
      }
    }
  }

  property var recursiveProcesses: ({})

  function scanDirectoryRecursive(screenName, directory) {
    if (!directory) {
      wallpaperLists[screenName] = [];
      wallpaperListChanged(screenName, 0);
      return;
    }

    if (recursiveProcesses[screenName]) {
      recursiveProcesses[screenName].running = false;
      recursiveProcesses[screenName].destroy();
      delete recursiveProcesses[screenName];
      scanningCount--;
    }

    scanningCount++;

    var processString = `
            import QtQuick
            import Quickshell.Io
            Process {
                id: process
                command: ["find", "` + directory + `", "-type", "f",
                    "(", "-iname", "*.jpg", "-o", "-iname", "*.jpeg",
                    "-o", "-iname", "*.png", "-o", "-iname", "*.gif",
                    "-o", "-iname", "*.pnm", "-o", "-iname", "*.bmp", ")"]
                stdout: StdioCollector {}
                stderr: StdioCollector {}
            }
        `;

    var processObject = Qt.createQmlObject(processString, root, "RecursiveScan_" + screenName);
    recursiveProcesses[screenName] = processObject;

    var handler = function (exitCode) {
      scanningCount--;

      if (exitCode === 0) {
        var lines = processObject.stdout.text.split("\n");
        var files = [];
        for (let i = 0; i < lines.length; i++) {
          var line = lines[i].trim();
          if (line !== "")
            files.push(line);
        }

        files.sort();
        wallpaperLists[screenName] = files;
        wallpaperListChanged(screenName, files.length);
      } else {
        wallpaperLists[screenName] = [];
        wallpaperListChanged(screenName, 0);
      }

      delete recursiveProcesses[screenName];
      processObject.destroy();
    };

    processObject.exited.connect(handler);
    processObject.running = true;
  }

  Instantiator {
    id: wallpaperScanners
    model: Quickshell.screens

    delegate: Item {
      id: scannerItem
      property string screenName: modelData.name
      property string targetDirectory: root.getMonitorDirectory(screenName)

      property var folderModel: null

      function createModel() {
        if (folderModel) {
          folderModel.destroy();
        }

        var component = Qt.createQmlObject(`
                    import QtQuick
                    import Qt.labs.folderlistmodel
                    FolderListModel {
                        id: model
                        folder: "file://${targetDirectory}"
                        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.pnm", "*.bmp"]
                        showDirs: false
                        sortField: FolderListModel.Name
                    }
                `, scannerItem, "FolderModel_" + screenName);

        component.statusChanged.connect(function () {
          if (component.status === FolderListModel.Null) {
            root.wallpaperLists[screenName] = [];
            root.wallpaperListChanged(screenName, 0);
          } else if (component.status === FolderListModel.Loading) {
            root.wallpaperLists[screenName] = [];
            root.scanningCount++;
          } else if (component.status === FolderListModel.Ready) {
            var files = [];
            for (let i = 0; i < component.count; i++) {
              var filepath = targetDirectory + "/" + component.get(i, "fileName");
              files.push(filepath);
            }
            root.wallpaperLists[screenName] = files;
            root.scanningCount--;
            root.wallpaperListChanged(screenName, files.length);
          }
        });

        folderModel = component;
      }

      Component.onCompleted: {
        createModel();

        root.wallpaperDirectoryChanged.connect(function (screen, directory) {
          if (screen === screenName) {
            targetDirectory = directory;
            createModel();
          }
        });
      }

      Component.onDestruction: {
        if (folderModel) {
          folderModel.destroy();
        }
      }
    }
  }
}
