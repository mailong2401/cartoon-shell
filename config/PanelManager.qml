// components/PanelManager.qml
import QtQuick 2.15

QtObject {
    id: panelManager

    // Properties cho từng panel
    property bool launcher: false
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
    function togglePanel(panelName) {
        switch(panelName) {
            case "launcher": launcher = !launcher; break
            case "cpu": cpu = !cpu; break
            case "ram": ram = !ram; break
            case "calendar": calendar = !calendar; break
            case "music": music = !music; break
            case "weather": weather = !weather; break
            case "flag": flag = !flag; break
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
        console.log("da dong het tat ca")
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
