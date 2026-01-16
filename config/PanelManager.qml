// components/PanelManager.qml
import QtQuick 2.15

QtObject {
    id: panelManager

    // Properties cho từng panel
    property bool launcher: false
    property bool launcherMask: false

    property bool cpu: false
    property bool cpuMask: false

    property bool ram: false
    property bool ramMask: false

    property bool calendar: false
    property bool calendarMask: false

    property bool music: false
    property bool musicMask: false

    property bool weather: false
    property bool weatherMask: false

    property bool flag: false
    property bool flagMask: false

    property bool bluetooth: false
    property bool bluetoothMask: false

    property bool wifi: false
    property bool wifiMask: false

    property bool mixer: false
    property bool mixerMask: false

    property bool battery: false
    property bool batteryMask: false

    property bool dashboard: false
    property bool dashboardMask: false

    property bool clock: currentConfig.clockPanelVisible  // Giữ nguyên từ config

    // Signal khi có panel thay đổi trạng thái
    signal panelChanged(string panelName, bool visible)

    // Hàm mở một panel duy nhất (đóng tất cả panel khác)
    function openPanel(panelName) {
        closeAllPanels()
        
        switch(panelName) {
            case "launcher": launcher = true; break
            case "cpu": cpu = true; break
            case "ram": ram = true; break
            case "calendar": calendar = true; break
            case "music": music = true; break
            case "weather": weather = true; break
            case "flag": flag = true; break
            case "bluetooth": bluetooth = true; break
            case "wifi": wifi = true; break
            case "mixer": mixer = true; break
            case "battery": battery = true; break
            case "dashboard": dashboard = true; break
            case "clock": clock = true; break
        }
        
        panelChanged(panelName, true)
    }

    // Hàm toggle panel
    // Hàm toggle panel
function togglePanel(panelName) {
    switch(panelName) {
        case "launcher": {
          if (launcher === false) {
            cpu = false
            ram = false
            weather = false
            launcher = true
          } else {
            launcher = false
          }
          break
        }
        case "cpu": cpu = !cpu; break
        case "ram": ram = !ram; break
        case "calendar": {
          if (!calendar) {
            weather = false
            flag = false
            calendar = true
          } else {
            calendar = false
          }
          break
        }

        case "music": {
            if (music === false) {
                calendar = false
                weather = false
                flag = false
                launcher = false
                cpu = false
                ram = false
                music = true
            } else {
                music = false
            }
            break
        }

        case "weather": {
          if (!weather) {
            flag = false
            calendar = false
            launcher = false
            weather = true
          } else {
            weather = false
          }
          break
        }
        case "flag": {
          if (!flag) {
            calendar = false
            weather = false
            flag = true
          } else {
            flag = false
          }
          break
        }
        case "bluetooth": bluetooth = !bluetooth; break
        case "wifi": wifi = !wifi; break
        case "mixer": mixer = !mixer; break
        case "battery": battery = !battery; break
        case "dashboard": dashboard = !dashboard; break
        case "clock": clock = !clock; break
    }

    panelChanged(panelName, getPanelVisible(panelName))
}


    // Hàm đóng tất cả panel
    function closeAllPanels() {
        launcher = false
        cpu = false
        ram = false
        calendar = false
        music = false
        weather = false
        flag = false
        bluetooth = false
        wifi = false
        mixer = false
        battery = false
        dashboard = false
        // Không đóng clock panel vì nó được điều khiển bởi config
    }

    // Hàm lấy trạng thái panel
    function getPanelVisible(panelName) {
        switch(panelName) {
            case "launcher": return launcher
            case "cpu": return cpu
            case "ram": return ram
            case "calendar": return calendar
            case "music": return music
            case "weather": return weather
            case "flag": return flag
            case "bluetooth": return bluetooth
            case "wifi": return wifi
            case "mixer": return mixer
            case "battery": return battery
            case "dashboard": return dashboard
            case "clock": return clock
            default: return false
        }
    }
}
