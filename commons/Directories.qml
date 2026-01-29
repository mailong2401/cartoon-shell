pragma Singleton

import QtQuick
import Quickshell

Singleton {
  property bool ready: false
  readonly property string shellName: "cartoon-shell"

  readonly property string home: Quickshell.env("HOME")
  readonly property string pictures: Quickshell.env("XDG_PICTURES_DIR") || `${home}/Pictures`
  readonly property string videos: Quickshell.env("XDG_VIDEOS_DIR") || `${home}/Videos`

  readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}`
  readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}`
  readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}`
  readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}`

  property string assetsPath: Quickshell.shellPath("assets")
  property string defaultAvatarPath: `${home}/.face`
  property string defaultWallpaperDir: `${pictures}/Wallpapers`
  property string shellConfig: `${config}/${shellName}`
  property string shellConfigColoursPath: `${shellConfig}/colours.json`
  property string shellConfigSettingsPath: `${shellConfig}/settings.json`
  property string shellConfigNotificationsPath: `${shellConfig}/notifications.json`
  property string shellState: `${state}/${shellName}`
  property string shellCache: `${cache}/${shellName}`
  property string shellCacheNetworkPath: `${shellCache}/network.json`
  property string shellCacheImagesDir: `${shellCache}/images`
  property string shellCacheWallpaperDir: `${shellCacheImagesDir}/wallpapers`
  property string shellCacheNotificationsDir: `${shellCacheImagesDir}/notifications`
  property string shellCacheThumbnailDir: `${shellCacheImagesDir}/thumbnails`
  property string shellCacheLauncherAppUsagePath: `${shellCache}/launcher_app_usage.json`
  property string shellDisplayCachePath: `${shellCache}/display.json`

  Component.onCompleted: {
    Quickshell.execDetached(["mkdir", "-p", `${shellConfig}`]);
    Quickshell.execDetached(["mkdir", "-p", `${shellState}`]);
    Quickshell.execDetached(["mkdir", "-p", `${shellCache}`]);
    Quickshell.execDetached(["mkdir", "-p", `${shellCacheImagesDir}`]);
    Quickshell.execDetached(["mkdir", "-p", `${shellCacheWallpaperDir}`]);
    Quickshell.execDetached(["mkdir", "-p", `${shellCacheNotificationsDir}`]);
    Quickshell.execDetached(["mkdir", "-p", `${shellCacheThumbnailDir}`]);

    ready = true;
  }
}
