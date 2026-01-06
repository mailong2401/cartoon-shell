// components/PanelManager.qml
import QtQuick 2.15

QtObject {
    id: panelManager

    // Properties cho từng panel
    property bool launcher: false
    property bool setting: false
    property bool fullsetting: false
    property bool listLauncher: false

    property bool cpu: false

    property bool ram: false

    property bool calendar: false

    property bool music: false

    property bool weather: false

    property bool flag: false

    property bool bluetooth: false

    property bool wifi: false

    property bool mixer: false

    property bool battery: false

    property bool dashboard: false

    property bool hasPanel : wifi || mixer || music || launcher || dashboard || battery || ram || cpu || calendar || weather || bluetooth

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
            listLauncher = true
            music = false
            dashboard = false
          } else {
            launcher = false
            setting = false
            listLauncher = false
            fullsetting = false
          }
          break
        }
        case "cpu": {
          if (!cpu) {
            cpu = true
            ram = false
            calendar = false
            weather = false
            music =  false
            flag = false
            launcher = false
            dashboard = false
            setting = false
            fullsetting = false
          } else {
            cpu = false
          }
          break
        }
        case "ram": {
          if (!ram) {
            ram = true
            cpu = false
            calendar = false
            flag = false
            music = false
            flag = false
            launcher = false
            dashboard = false
            setting = false
            fullsetting = false
          } else {
            ram = false
          }
          break
        }
        case "calendar": {
          if (!calendar) {
            ram = false
            cpu = false
            weather = false
            flag = false
            music = false
            calendar = true
            dashboard = false
            if (setting) {
              launcher = false
            }
            setting = false
            fullsetting = false
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
                setting = false
                fullsetting = false
            dashboard = false
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
            music = false
            dashboard = false
            setting = false
            fullsetting = false
          } else {
            weather = false
          }
          break
        }
        case "flag": {
          if (!flag) {
            calendar = false
            weather = false
            music = false
            flag = true
            dashboard = false
            setting = false
            fullsetting = false
          } else {
            flag = false
          }
          break
        }
        case "bluetooth": {
          if (!bluetooth) {
            wifi = false
            mixer = false
            battery = false
            bluetooth = true
            dashboard = false
            setting = false
            fullsetting = false
          } else {
            bluetooth = false
          }
          break
        }
        case "wifi": {
          if (!wifi) {
            wifi = true
            mixer = false
            bluetooth = false
            battery = false
            dashboard = false
            setting = false
            fullsetting = false
          } else {
            wifi = false
          }
          break
        }
        case "mixer": {
          if (!mixer) {
            mixer = true
            wifi = false
            bluetooth = false
            battery = false
            dashboard = false
            setting = false
            fullsetting = false

          } else {
            mixer = false
          }
          break
        }
        case "battery": {
          if (!battery) {
            mixer = false
            bluetooth = false
            wifi = false
            battery = true
            dashboard = false
            setting = false
            fullsetting = false
          } else {
            battery = false
          }
          break
        }
        case "dashboard": {
          if (!dashboard) {
            launcher = false
            battery = false
            wifi = false
            bluetooth = false
            mixer = false
            calendar = false
            cpu = false
            ram = false
            flag = false
            music = false
            weather = false
            dashboard = true
            setting = false
            fullsetting = false
          } else {
            dashboard = false
          }
          break
        }
        case "setting": {
          calendar = false
          setting = true
          break
        }
        case "fullsetting": {
          fullsetting = !fullsetting
          break
        }
        case "listLauncher" : {
          setting = false
        }
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
        setting = false
        fullsetting = false
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
