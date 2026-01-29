pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.commons
import qs.services

Variants {
  id: backgroundVariants
  model: Quickshell.screens

  delegate: Loader {
    id: loader
    required property ShellScreen modelData

    active: modelData && Settings.wallpaper.enabled

    sourceComponent: PanelWindow {
      id: root

      // Internal state management
      property string transitionType: "fade"
      property real transitionProgress: 0

      readonly property real edgeSmoothness: Settings.wallpaper.transitionEdgeSmoothness
      readonly property bool transitioning: transitionAnimation.running

      // Wipe direction: 0=left, 1=right, 2=up, 3=down
      property real wipeDirection: 0

      // Disc
      property real discCenterX: 0.5
      property real discCenterY: 0.5

      // Stripe
      property real stripesCount: 16
      property real stripesAngle: 0

      // Used to debounce wallpaper changes
      property string futureWallpaper: ""

      // Fillmode default is "crop"
      property real fillMode: WallpaperService.getFillModeUniform()
      property vector4d fillColor: Qt.vector4d(Settings.wallpaper.fillColor.r, Settings.wallpaper.fillColor.g, Settings.wallpaper.fillColor.b, 1.0)

      color: "transparent"
      screen: loader.modelData
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "quickshell:wallpaper-" + (screen?.name || "unknown")

      anchors {
        bottom: true
        top: true
        right: true
        left: true
      }

      Timer {
        id: debounceTimer
        interval: 333
        running: false
        repeat: false
        onTriggered: {
          root.changeWallpaper();
        }
      }

      Component.onCompleted: setWallpaperInitial()

      Component.onDestruction: {
        transitionAnimation.stop();
        debounceTimer.stop();
        shaderLoader.active = false;
        currentWallpaper.source = "";
        nextWallpaper.source = "";
      }

      Connections {
        target: WallpaperService
        function onWallpaperChanged(screenName, path) {
          if (screenName === loader.modelData.name) {
            root.futureWallpaper = path;
            debounceTimer.restart();
          }
        }
      }

      Connections {
        target: CompositorService
        function onDisplayScalesChanged() {
          root.setWallpaperInitial();
        }
      }

      Image {
        id: currentWallpaper

        property bool dimensionsCalculated: false

        source: ""
        smooth: true
        mipmap: false
        visible: false
        cache: false
        asynchronous: true
        sourceSize: undefined
        onStatusChanged: {
          if (status === Image.Error) {
            console.log("Current wallpaper failed to load:", source);
          } else if (status === Image.Ready && !dimensionsCalculated) {
            dimensionsCalculated = true;
            const optimalSize = root.calculateOptimalWallpaperSize(implicitWidth, implicitHeight);
            if (optimalSize !== false) {
              sourceSize = optimalSize;
            }
          }
        }
        onSourceChanged: {
          dimensionsCalculated = false;
          sourceSize = undefined;
        }
      }

      Image {
        id: nextWallpaper

        property bool dimensionsCalculated: false

        source: ""
        smooth: true
        mipmap: false
        visible: false
        cache: false
        asynchronous: true
        sourceSize: undefined
        onStatusChanged: {
          if (status === Image.Error) {} else if (status === Image.Ready && !dimensionsCalculated) {
            dimensionsCalculated = true;
            const optimalSize = root.calculateOptimalWallpaperSize(implicitWidth, implicitHeight);
            if (optimalSize !== false) {
              sourceSize = optimalSize;
            }
          }
        }
        onSourceChanged: {
          dimensionsCalculated = false;
          sourceSize = undefined;
        }
      }

      Loader {
        id: shaderLoader
        anchors.fill: parent
        active: true
        sourceComponent: ShaderEffect {
          anchors.fill: parent

          property variant source1: currentWallpaper
          property variant source2: nextWallpaper
          property real progress: root.transitionProgress
          property real smoothness: root.edgeSmoothness
          property real aspectRatio: root.width / root.height
          property real stripeCount: root.stripesCount
          property real angle: root.stripesAngle

          // Fill mode properties
          property real fillMode: root.fillMode
          property vector4d fillColor: root.fillColor
          property real imageWidth1: source1.sourceSize.width
          property real imageHeight1: source1.sourceSize.height
          property real imageWidth2: source2.sourceSize.width
          property real imageHeight2: source2.sourceSize.height
          property real screenWidth: width
          property real screenHeight: height

          fragmentShader: Qt.resolvedUrl(Quickshell.shellDir + "/shaders/qsb/wp_stripes.frag.qsb")
        }
      }

      NumberAnimation {
        id: transitionAnimation
        target: root
        property: "transitionProgress"
        from: 0.0
        to: 1.0
        // The stripes shader feels faster visually, we make it a bit slower here.
        duration: Settings.wallpaper.transitionDuration
        easing.type: Easing.InOutCubic
        onFinished: {
          // Assign new image to current BEFORE clearing to prevent flicker
          const tempSource = nextWallpaper.source;
          currentWallpaper.source = tempSource;
          root.transitionProgress = 0.0;

          // Now clear nextWallpaper after currentWallpaper has the new source
          // Force complete cleanup to free texture memory (~18-25MB per monitor)
          Qt.callLater(() => {
            nextWallpaper.source = "";
            nextWallpaper.sourceSize = undefined;
            Qt.callLater(() => {
              currentWallpaper.asynchronous = true;
            });
          });
        }
      }

      function setWallpaperInitial() {
        // On startup, defer assigning wallpaper until the service cache is ready, retries every tick
        if (!WallpaperService || !WallpaperService.isInitialized) {
          Qt.callLater(setWallpaperInitial);
          return;
        }

        setWallpaperImmediate(WallpaperService.getWallpaper(loader.modelData.name));
      }

      function setWallpaperImmediate(source) {
        transitionAnimation.stop();
        transitionProgress = 0.0;

        // Clear nextWallpaper completely to free texture memory
        nextWallpaper.source = "";
        nextWallpaper.sourceSize = undefined;

        Qt.callLater(() => {
          currentWallpaper.source = source;
        });
      }

      function calculateOptimalWallpaperSize(wpWidth, wpHeight) {
        const compositorScale = CompositorService.getDisplayScale(loader.modelData.name);
        const screenWidth = loader.modelData.width * compositorScale;
        const screenHeight = loader.modelData.height * compositorScale;

        if (wpWidth <= screenWidth || wpHeight <= screenHeight || wpWidth <= 0 || wpHeight <= 0) {
          return;
        }

        const imageAspectRatio = wpWidth / wpHeight;
        var dim = Qt.size(0, 0);
        if (screenWidth >= screenHeight) {
          const w = Math.min(screenWidth, wpWidth);
          dim = Qt.size(w, w / imageAspectRatio);
        } else {
          const h = Math.min(screenHeight, wpHeight);
          dim = Qt.size(h * imageAspectRatio, h);
        }

        return dim;
      }

      function setWallpaperWithTransition(source) {
        if (source === currentWallpaper.source) {
          return;
        }

        if (transitioning) {
          transitionAnimation.stop();
          transitionProgress = 0;

          const newCurrentSource = nextWallpaper.source;
          currentWallpaper.source = newCurrentSource;

          Qt.callLater(() => {
            nextWallpaper.source = "";

            Qt.callLater(() => {
              nextWallpaper.source = source;
              currentWallpaper.asynchronous = false;
              transitionAnimation.start();
            });
          });
          return;
        }

        nextWallpaper.source = source;
        currentWallpaper.asynchronous = false;
        transitionAnimation.start();
      }

      function changeWallpaper() {
        stripesCount = Math.round(Math.random() * 20 + 4);
        stripesAngle = Math.random() * 360;
        setWallpaperWithTransition(futureWallpaper);
      }
    }
  }
}
