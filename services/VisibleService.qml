// components/PanelManager.qml
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick 2.15
import Quickshell
import qs.commons

Singleton {
    id: panelManager

    property bool isVertical: Settings.bar.position === "left" || Settings.bar.position === "right"

    // --- State Properties ---
    property bool launcher: false
    property bool setting: false
    property bool fullsetting: false
    property bool tray: false
    property bool listLauncher: false
    property bool keyboard: false
    property bool filedialog: false
    property bool cpu: false
    property bool lockscreen: false
    property bool packagePanel: false
    property bool keybind: false
    property bool ram: false
    property bool calendar: false
    property bool music: false
    property bool weather: false
    property bool shortcutMenu: false
    property bool flag: false
    property bool bluetooth: false
    property bool wifi: false
    property bool mixer: false
    property bool battery: false
    property bool dashboard: false

    property bool hasPanel: tray || packagePanel || wifi || flag || mixer || music || launcher || dashboard || battery || ram || cpu || calendar || weather || bluetooth
    property bool clock: Settings.clock.enableWidget

    signal panelChanged(string panelName, bool visible)

    // Danh sách các panel chính dùng để reset/close hàng loạt
    readonly property var managedPanels: ["launcher", "shortcutMenu", "cpu", "ram", "calendar", "music", "weather", "flag", "tray", "bluetooth", "wifi", "mixer", "battery", "dashboard", "setting", "fullsetting", "packagePanel", "filedialog"]

    // Helper: Đặt giá trị cho nhiều panel cùng lúc
    function setPanels(panelList, value) {
        for (let i = 0; i < panelList.length; i++) {
            let p = panelList[i];
            if (panelManager.hasOwnProperty(p)) {
                panelManager[p] = value;
            }
        }
    }

    // Hàm mở một panel duy nhất (đóng tất cả panel khác)
    function openPanel(panelName) {
        closeAllPanels();
        if (panelManager.hasOwnProperty(panelName)) {
            panelManager[panelName] = true;
        }
        panelChanged(panelName, true);
    }

    // Hàm đóng tất cả panel
    function closeAllPanels() {
        setPanels(managedPanels, false);
    }

    // Hàm lấy trạng thái panel
    function getPanelVisible(panelName) {
        if (panelName === "hasPanel")
            return hasPanel;
        if (panelName === "clock")
            return clock;
        return panelManager.hasOwnProperty(panelName) ? panelManager[panelName] : false;
    }

    // Hàm toggle panel (Giữ nguyên chính xác 100% logic điều kiện của bạn)
    function togglePanel(panelName) {
        switch (panelName) {
        case "shortcutMenu":
            shortcutMenu = !shortcutMenu;
            break;
        case "keyboard":
            keyboard = !keyboard;
            break;
        case "launcher":
            if (!launcher) {
                setPanels(["cpu", "ram", "shortcutMenu", "weather", "music", "dashboard", "keybind"], false);
                if (isVertical) {
                    setPanels(["flag", "calendar", "mixer", "wifi", "bluetooth"], false);
                }
                launcher = true;
                listLauncher = true;
            } else {
                setPanels(["launcher", "setting", "listLauncher", "fullsetting"], false);
            }
            break;
        case "cpu":
            if (!cpu) {
                setPanels(["ram", "calendar", "flag", "music", "shortcutMenu", "weather", "launcher", "dashboard", "setting", "keybind", "fullsetting"], false);
                cpu = true;
            } else {
                cpu = false;
            }
            break;
        case "ram":
            if (!ram) {
                setPanels(["cpu", "calendar", "flag", "music", "shortcutMenu", "weather", "launcher", "dashboard", "keybind", "setting", "fullsetting"], false);
                ram = true;
            } else {
                ram = false;
            }
            break;
        case "calendar":
            if (!calendar) {
                setPanels(["ram", "cpu", "shortcutMenu", "weather", "keybind", "flag", "music", "dashboard", "setting", "fullsetting"], false);
                if (isVertical) {
                    setPanels(["launcher", "mixer", "wifi", "battery", "bluetooth"], false);
                }
                calendar = true;
                if (setting)
                    launcher = false;
            } else {
                calendar = false;
            }
            break;
        case "music":
            if (!music) {
                setPanels(["calendar", "weather", "flag", "launcher", "shortcutMenu", "cpu", "keybind", "ram", "setting", "fullsetting", "dashboard"], false);
                if (isVertical) {
                    setPanels(["battery", "mixer", "wifi", "bluetooth"], false);
                }
                music = true;
            } else {
                music = false;
            }
            break;
        case "weather":
            if (!weather) {
                setPanels(["flag", "calendar", "launcher", "mixer", "keybind", "wifi", "shortcutMenu", "bluetooth", "battery", "cpu", "music", "dashboard", "ram", "setting", "tray", "fullsetting"], false);
                weather = true;
            } else {
                weather = false;
            }
            break;
        case "flag":
            if (!flag) {
                setPanels(["calendar", "weather", "music", "shortcutMenu", "dashboard", "ram", "cpu", "keybind", "setting", "fullsetting"], false);
                if (isVertical) {
                    setPanels(["launcher", "wifi", "mixer", "bluetooth"], false);
                }
                flag = true;
            } else {
                flag = false;
            }
            break;
        case "bluetooth":
            if (!bluetooth) {
                setPanels(["wifi", "mixer", "shortcutMenu", "battery", "tray", "weather", "dashboard", "keybind", "setting", "fullsetting"], false);
                if (isVertical) {
                    setPanels(["launcher", "music", "flag", "calendar"], false);
                }
                bluetooth = true;
            } else {
                bluetooth = false;
            }
            break;
        case "wifi":
            if (!wifi) {
                setPanels(["mixer", "bluetooth", "shortcutMenu", "battery", "keybind", "dashboard", "setting", "weather", "tray", "fullsetting"], false);
                if (isVertical) {
                    setPanels(["music", "calendar", "launcher", "flag"], false);
                }
                wifi = true;
            } else {
                wifi = false;
            }
            break;
        case "mixer":
            if (!mixer) {
                setPanels(["shortcutMenu", "wifi", "bluetooth", "battery", "dashboard", "setting", "keybind", "tray", "weather", "fullsetting"], false);
                if (isVertical) {
                    setPanels(["launcher", "music", "calendar", "flag"], false);
                }
                mixer = true;
            } else {
                mixer = false;
            }
            break;
        case "battery":
            if (!battery) {
                setPanels(["mixer", "bluetooth", "shortcutMenu", "wifi", "dashboard", "tray", "keybind", "weather", "setting", "fullsetting"], false);
                if (isVertical) {
                    setPanels(["launcher", "music", "calendar"], false);
                }
                battery = true;
            } else {
                battery = false;
            }
            break;
        case "packagePanel":
            if (!packagePanel) {
                setPanels(["launcher", "battery", "shortcutMenu", "wifi", "bluetooth", "mixer", "calendar", "cpu", "ram", "flag", "keybind", "music", "weather", "setting", "dashboard", "fullsetting"], false);
                packagePanel = true;
            } else {
                packagePanel = false;
            }
            break;
        case "dashboard":
            if (!dashboard) {
                setPanels(["launcher", "battery", "shortcutMenu", "wifi", "bluetooth", "mixer", "calendar", "cpu", "packagePanel", "ram", "flag", "music", "weather", "keybind", "setting", "fullsetting"], false);
                dashboard = true;
            } else {
                dashboard = false;
            }
            break;
        case "keybind":
            if (!keybind) {
                setPanels(["launcher", "battery", "wifi", "shortcutMenu", "bluetooth", "mixer", "calendar", "cpu", "packagePanel", "ram", "flag", "music", "weather", "dashboard", "setting", "fullsetting"], false);
                keybind = true;
            } else {
                keybind = false;
            }
            break;
        case "tray":
            if (!tray) {
                setPanels(["wifi", "mixer", "bluetooth", "shortcutMenu", "battery", "weather", "dashboard"], false);
                tray = true;
            } else {
                tray = false;
            }
            break;
        case "setting":
            setPanels(["calendar", "flag", "shortcutMenu", "keybind"], false);
            setting = true;
            break;
        case "fullsetting":
            fullsetting = !fullsetting;
            shortcutMenu = false;
            break;
        case "filedialog":
            filedialog = !filedialog;
            shortcutMenu = false;
            break;
        case "listLauncher":
            setting = false;
            shortcutMenu = false;
            break;
        }

        panelChanged(panelName, getPanelVisible(panelName));
    }
}
