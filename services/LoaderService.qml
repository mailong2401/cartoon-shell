import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.panels
import qs.commons
import qs.services

Item {
    id: root

    Loader {
        source: "../modules/widgets/WidgetLeft.qml"
        active: true
        onLoaded: {
            item.visible = Qt.binding(function () {
                true;
            });
        }
    }
    Loader {
        source: "../modules/widgets/WidgetRight.qml"
        active: true
        onLoaded: {
            item.visible = Qt.binding(function () {
                true;
            });
        }
    }

    Loader {
        source: "../modules/panels/package/PackagePanel.qml"
        active: VisibleService.packagePanel
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.packagePanel;
            });
        }
    }

    Loader {
        source: "../modules/panels/tray/trayPanel.qml"
        active: VisibleService.tray
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.tray;
            });
        }
    }
    Loader {
        source: "../modules/panels/calendar/CalendarPanel.qml"
        active: VisibleService.calendar
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.calendar;
            });
        }
    }

    // Flag Selection Panel
    Loader {
        source: "../modules/panels/flag/FlagPanel.qml"
        active: VisibleService.flag
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.flag;
            });
        }
    }
    Loader {
        source: "../modules/panels/keybind/KeyBindPanel.qml"
        active: VisibleService.keybind
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.keybind;
            });
        }
    }

    property bool anchorsTop: Settings.clock.positionWidget === "top" || Settings.clock.positionWidget === "topLeft" || Settings.clock.positionWidget === "topRight"
    property bool anchorsBottom: Settings.clock.positionWidget === "bottom" || Settings.clock.positionWidget === "bottomLeft" || Settings.clock.positionWidget === "bottomRight"
    property bool anchorsRight: Settings.clock.positionWidget === "right" || Settings.clock.positionWidget === "topRight" || Settings.clock.positionWidget === "bottomRight"
    property bool anchorsLeft: Settings.clock.positionWidget === "left" || Settings.clock.positionWidget === "topLeft" || Settings.clock.positionWidget === "bottomLeft"

    ClockPanel {
        id: clockPanel
        visible: Settings.clock.enableWidget
        anchors {
            top: anchorsTop
            bottom: anchorsBottom
            left: anchorsLeft
            right: anchorsRight
        }
    }

    // Weather Panel
    Loader {
        source: "../modules/panels/weather/WeatherPanel.qml"
        active: VisibleService.weather
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.weather;
            });
        }
    }
    Loader {
        source: "../modules/panels/cpu/CpuDetailPanel.qml"
        active: VisibleService.cpu
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.cpu;
            });
        }
    }
    Loader {
        source: "../modules/panels/ram/RamDetailPanel.qml"
        active: VisibleService.ram
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.ram;
            });
        }
    }
    Loader {
        source: "../modules/panels/keyboard/KeyboardPanel.qml"
        active: VisibleService.keyboard
        onLoaded: {
            item.visible = VisibleService.keyboard;
        }
    }
    Loader {
        active: VisibleService.music
        source: "../modules/panels/music/MusicPanel.qml"
        onLoaded: {
            item.visible = VisibleService.music;
        }
    }

    Loader {
        active: false
        source: "../modules/panels/win11/actionCenter/ActionCenterPanel.qml"
        onLoaded: {
            item.visible = false;
        }
    }

    Loader {
        source: "../modules/panels/wifi/WifiPanel.qml"
        active: VisibleService.wifi
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.wifi;
            });
        }
    }

    Loader {
        source: "../modules/panels/bluetooth/BluetoothPanel.qml"
        active: VisibleService.bluetooth
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.bluetooth;
            });
        }
    }

    Loader {
        source: "../modules/panels/mixer/MixerPanel.qml"
        active: VisibleService.mixer
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.mixer;
            });
        }
    }
    Loader {
        source: "../modules/panels/battery/BatteryDetailPanel.qml"
        active: VisibleService.battery
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.battery;
            });
        }
    }

    Loader {
        source: "../modules/panels/dashboard/DashboardPanel.qml"
        active: VisibleService.dashboard
        onLoaded: {
            item.visible = Qt.binding(function () {
                return VisibleService.dashboard;
            });
        }
    }
    Loader {
        id: launcherPanelLoader
        source: "../modules/panels/launcher/LauncherPanel.qml"
        active: VisibleService.launcher
        onLoaded: {
            item.visible = VisibleService.launcher;
            item.confirmRequested.connect(function (action, actionLabel) {
                confirmDialog.show(action, actionLabel);
            });
        }
    }
    IpcHandler {
        id: ipc
        target: "rect"
        function getToggle() {
            VisibleService.togglePanel("launcher");
        }
    }
    IpcHandler {
        target: "dashboard"
        function getToggle() {
            VisibleService.togglePanel("dashboard");
        }
    }
    IpcHandler {
        target: "ram"
        function getToggle() {
            VisibleService.togglePanel("ram");
        }
    }
    IpcHandler {
        target: "cpu"
        function getToggle() {
            VisibleService.togglePanel("cpu");
        }
    }
    IpcHandler {
        target: "weather"
        function getToggle() {
            if (Settings.bar.style === 1) {
                VisibleService.togglePanel("weather");
            }
        }
    }
    IpcHandler {
        target: "calendar"
        function getToggle() {
            VisibleService.togglePanel("calendar");
        }
    }
    IpcHandler {
        target: "wifi"
        function getToggle() {
            VisibleService.togglePanel("wifi");
        }
    }
    IpcHandler {
        target: "bluetooth"
        function getToggle() {
            if (Settings.bar.style === 1) {
                VisibleService.togglePanel("bluetooth");
            }
        }
    }
    IpcHandler {
        target: "mixer"
        function getToggle() {
            VisibleService.togglePanel("mixer");
        }
    }
    IpcHandler {
        target: "battery"
        function getToggle() {
            VisibleService.togglePanel("battery");
        }
    }
    IpcHandler {
        target: "keyboard"
        function getToggle() {
            VisibleService.togglePanel("keyboard");
        }
    }
    IpcHandler {
        target: "keybind"
        function getToggle() {
            VisibleService.togglePanel("keybind");
        }
    }
}
