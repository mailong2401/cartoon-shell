import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: networkService
    
    // Properties
    property string net_stat: "Checking..."
    property string wifi_icon: "../../assets/wifi/wifi.png"
    property int signal_current: 0
    
    // Signals
    signal wifiUpdated()
    
    // Processes
    Process {
        id: wifiProcess
        command: [Qt.resolvedUrl("../scripts/check-network"), "--stat"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                networkService.net_stat = result
                networkService.updateWifiIcon()
                networkService.wifiUpdated()
            }
        }
    }

    Process {
        id: wifiSignalProcess
        command: ["bash", "-c", "nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2"]
        stdout: StdioCollector { }
        running: false
        onRunningChanged: {
            if (!running && stdout.text) {
                var resultText = stdout.text.trim()
                if (resultText) {
                    var result = parseInt(resultText)
                    if (!isNaN(result)) {
                        networkService.signal_current = result
                    } else {
                        networkService.signal_current = 0
                    }
                } else {
                    networkService.signal_current = 0
                }
                networkService.updateWifiIcon()
                networkService.wifiUpdated()
            }
        }
    }
    
    // Functions
    function updateWifi() {
        if (!wifiProcess.running) {
            wifiProcess.running = true
        }
    }
    
    function updateSignalWifi() {
        if (!wifiSignalProcess.running) {
            wifiSignalProcess.running = true
        }
    }
    
    function updateWifiIcon() {
        if (networkService.net_stat === "Offline") {
            networkService.wifi_icon = "../../assets/wifi/no-wifi.png"
        } else if (networkService.net_stat === "Online") {
            networkService.wifi_icon = "../../assets/wifi/wifi.png"
        } else {
            var signal = networkService.signal_current || 0
            if (signal <= 40) {
                networkService.wifi_icon = "../../assets/wifi/wifi_1.png"
            } else if (signal <= 70) {
                networkService.wifi_icon = "../../assets/wifi/wifi_2.png"
            } else {
                networkService.wifi_icon = "../../assets/wifi/wifi.png"
            }
        }
    }
    
    // Timers
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: networkService.updateWifi()
    }
    
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: networkService.updateSignalWifi()
    }
}
