pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.services

Singleton {
  id: root

  property bool isNiri: false
  property bool isHyprland: false
  property bool isSway: false

  property var lockscreen: null

  property ListModel workspaces: ListModel {}
  property ListModel windows: ListModel {}
  property int focusedWindowIndex: -1

  property alias displayScales: displayCacheAdapter.displays
  property bool displayScalesLoaded: false

  property var backend: null

  property string displayCachePath: Directories.shellDisplayCachePath

  signal workspaceChanged
  signal activeWindowChanged
  signal windowListChanged

  Component.onCompleted: {
    detectCompositor();
  }

  FileView {
    id: displayCacheFileView
    path: root.displayCachePath
    printErrors: false
    watchChanges: false
    onLoaded: {
      root.displayScalesLoaded = true;
    }
    onLoadFailed: {
      root.displayScalesLoaded = true;
    }
    onAdapterUpdated: {
      writeAdapter();
    }

    JsonAdapter {
      id: displayCacheAdapter
      property var displays: ({})
    }
  }

  function onDisplayScalesUpdated(scales) {
    displayScales = scales;
    displayScalesChanged();
  }

  function getDisplayScale(displayName) {
    if (!displayName || !displayScales[displayName]) {
      return 1.0;
    }
    return displayScales[displayName].scale || 1.0;
  }

  function getActiveWorkspaceId(outputName) {
    if (!outputName)
      return -1;
    const target = outputName.toLowerCase();

    for (let i = 0; i < workspaces.count; i++) {
      const ws = workspaces.get(i);
      if (ws.output.toLowerCase() === target && ws.isActive) {
        return ws.id;
      }
    }
    return -1;
  }

  function detectCompositor() {
    const niriSocket = Quickshell.env("NIRI_SOCKET");
    const hyprlandSignature = Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE");
    const swaySock = Quickshell.env("SWAYSOCK");

    if (niriSocket && niriSocket.length > 0) {
      isNiri = true;
      isHyprland = false;
      isSway = false;
      backendLoader.sourceComponent = niriComponent;
    } else if (hyprlandSignature && hyprlandSignature.length > 0) {
      isNiri = false;
      isHyprland = true;
      isSway = false;
      backendLoader.sourceComponent = hyprlandComponent;
    } else if (swaySock && swaySock.length > 0) {
      isNiri = false;
      isHyprland = false;
      isSway = true;
    } else {
      isNiri = true;
      isHyprland = false;
      isSway = false;
      backendLoader.sourceComponent = niriComponent;
    }
  }

  Loader {
    id: backendLoader
    onLoaded: {
      if (item) {
        root.backend = item;
        root.setupBackendConnections();
        root.backend.initialize();
      }
    }
  }

  Component {
    id: niriComponent
    NiriService {
      id: niriBackend
    }
  }

  Component {
    id: hyprlandComponent
    HyprlandService {
      id: hyprlandBackend
    }
  }

  function setupBackendConnections() {
    if (!backend)
      return;

    // Workspaces
    backend.workspaceChanged.connect(() => {
      syncWorkspaces();
      workspaceChanged();
    });

    // Active window
    backend.activeWindowChanged.connect(() => {
      syncWindows();
      activeWindowChanged();
    });

    // Window list
    backend.windowListChanged.connect(() => {
      syncWindows();
      windowListChanged();
    });

    // Focused window index
    backend.focusedWindowIndexChanged.connect(() => {
      focusedWindowIndex = backend.focusedWindowIndex;
    });

    // Initial sync
    syncWorkspaces();
    syncWindows();
    focusedWindowIndex = backend.focusedWindowIndex;
  }

  function syncWorkspaces() {
    workspaces.clear();
    const ws = backend.workspaces;
    for (var i = 0; i < ws.count; i++) {
      workspaces.append(ws.get(i));
    }
    // Emit signal to notify listeners that workspace list has been updated
    workspacesChanged();
  }

  function syncWindows() {
    windows.clear();
    const ws = backend.windows;
    for (var i = 0; i < ws.length; i++) {
      windows.append(ws[i]);
    }
    // Emit signal to notify listeners that workspace list has been updated
    windowListChanged();
  }

  function switchToWorkspace(workspace) {
    if (backend && backend.switchToWorkspace) {
      backend.switchToWorkspace(workspace);
    } else {
      console.log("Compositor", "No backend available for workspace switching");
    }
  }

  function logout() {
    if (backend && backend.logout) {
      backend.logout();
    }
  }

  function shutdown() {
    Quickshell.execDetached(["sh", "-c", "systemctl poweroff || loginctl poweroff"]);
  }

  function reboot() {
    Quickshell.execDetached(["sh", "-c", "systemctl reboot || loginctl reboot"]);
  }

  function suspend() {
    Quickshell.execDetached(["sh", "-c", "systemctl suspend || loginctl suspend"]);
  }

  function lock() {
    try {
      if (root.lockscreen) {
        root.lockscreen.locked = true;
        CavaService.registerComponent("lockscreen");
      }
    } catch (e) {}
  }

  function lockAndSuspend() {
    try {
      if (root.lockscreen) {
        root.lockscreen.locked = true;
        CavaService.registerComponent("lockscreen");
      }
    } catch (e) {}
    Qt.callLater(suspend);
  }
}
