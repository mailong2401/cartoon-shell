import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../../services/" as Service


Rectangle {
    id: root
    border.color: theme.button.border
    border.width: 3
    radius: 10
    color: theme.primary.background


    property string bluetooth_icon: "../../assets/settings/bluetooth.png"
    property string status_battery: "Unknown"
    property string capacity_battery: "..."
    property bool shouldShowOsd: false
    property bool visibleMixerPanel: false
    property bool visibleBatteryPanel: false
    property bool wifiPanelVisible: false
    property bool visibleDashboard: false
    property bool bluetoothVisible: true
    property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0
    property bool isMuted: Pipewire.defaultAudioSink?.audio.mute ?? false
    property var theme : currentTheme


    Service.NetworkService{
      id: networkService
    }



    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
      }
          Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }
    
    
    // WifiManager component - chứa tất cả logic WiFi
    // WiFi Panel - chỉ hiện khi được toggle
    //




    // =============================
    //   PROCESSES
    // =============================
    


    Process {
        id: batteryCapacityProcess
        command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.capacity_battery = result
                updateBatteryIcon()
            }
        }
    }

    Process {
        id: batteryStatusProcess
        command: ["cat", "/sys/class/power_supply/BAT1/status"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.status_battery = result
                updateBatteryIcon()
            }
        }
    }

    Process {
        id: volumeCurrentProcess
        command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+%' | head -1"]
        running: false
        stdout: StdioCollector { }
        onRunningChanged: {
            if (!running && stdout.text) {
                var result = stdout.text.trim()
                root.volumeCurrent = result
                updateVolumeIcon()
            }
        }
    }

    // =============================
    //   FUNCTIONS
    // =============================
    
    function updateBatteryCappacityProcess() {
        if (!batteryCapacityProcess.running) {
            batteryCapacityProcess.running = true
        }
    }







    function updateBatteryIcon() {
        var capacity = parseInt(root.capacity_battery) || 0
        var status = root.status_battery
        
        if (status === "Charging") {
            batteryIcon.source = '../../assets/battery/battery-1.png'
        } else if (capacity <= 20) {
            batteryIcon.source = '../../assets/battery/battery-2.png'
        } else if (capacity <= 50) {
            batteryIcon.source = '../../assets/battery/battery-2.png'
        } else if (capacity <= 80) {
            batteryIcon.source = '../../assets/battery/battery-3.png'
        } else {
            batteryIcon.source = '../../assets/battery/full.png'
        }
    }




    // =============================
    //   UI LAYOUT
    // =============================
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5
        Rectangle {
            id: bluetoothContainer
            Layout.preferredWidth:  bluetoothContent.width
            Layout.fillHeight: true
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: bluetoothContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: bluetoothImage
                    source: root.bluetooth_icon
                    width: 35
                    height: 35
                    sourceSize: Qt.size(35, 35)
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true

                onEntered: bluetoothContainer.scale = 1.1
                onExited: bluetoothContainer.scale = 1.0
                onPressed: bluetoothContainer.scale = 0.95
                onReleased: bluetoothContainer.scale = containsMouse ? 1.1 : 1.0

                onClicked: panelManager.togglePanel("bluetooth")
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
        Item { Layout.fillWidth: true }

        // Network Status
        Rectangle {
            id: networkContainer
            Layout.preferredWidth: networkContent.width
            Layout.fillHeight: true
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: networkContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: wifiImage
                    source: networkService.wifi_icon
                    width: 35
                    height: 35
                    sourceSize: Qt.size(35, 35)
                }
                
                Text {
                  Layout.maximumWidth: 120 
                    text: networkService.net_stat
                    color: theme.primary.foreground
                    font {
                        pixelSize: 15
                        bold: true
                    }
                    wrapMode: Text.WordWrap
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true

                onEntered: networkContainer.scale = 1.1
                onExited: networkContainer.scale = 1.0
                onPressed: networkContainer.scale = 0.95
                onReleased: networkContainer.scale = containsMouse ? 1.1 : 1.0

                onClicked: panelManager.togglePanel("wifi")
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Volume
        Rectangle {
            id: volumeContainer
            Layout.preferredWidth:  volumeContent.width
            Layout.fillHeight: true
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: volumeContent
                anchors.centerIn: parent

                Image {
                    id: volumeIcon
                    source: isMuted || currentVolume === 0 ? "../../assets/volume/mute.png" : "../../assets/volume/volume.png"
                    width: 35
                    height: 35
                    sourceSize: Qt.size(35, 35)
                }
                Text {
                    text: isMuted ? "Muted" : Math.round(currentVolume * 100) + "%"

                    color: theme.primary.foreground
                    font { 
                        pixelSize: 16
                        bold: true 
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                preventStealing: true

                onEntered: volumeContainer.scale = 1.1
                onExited: volumeContainer.scale = 1.0
                onPressed: volumeContainer.scale = 0.95
                onReleased: volumeContainer.scale = containsMouse ? 1.1 : 1.0
                onClicked: {
                  panelManager.togglePanel("mixer")

                }
                onWheel: {
                    var delta = wheel.angleDelta.y / 120
                    if (delta > 0) {
                        Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]; running: true }', root)
                    } else {
                        Qt.createQmlObject('import Quickshell; Process { command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]; running: true }', root)
                    }
                    updateVolumeCurrentProcess()
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Battery
        Rectangle {
            id: batteryContainer
            Layout.preferredWidth: batteryContent.width
            Layout.fillHeight: true
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            RowLayout {
                id: batteryContent
                anchors.centerIn: parent
                spacing: 8

                Image {
                    id: batteryIcon
                    source: '../../assets/battery/full.png'
                    width: 30
                    height: 30
                    sourceSize: Qt.size(30, 30)
                }
                Text {
                    text: root.capacity_battery + "%"
                    color: theme.primary.foreground
                    font { 
                        pixelSize: 16
                        bold: true 
                    }
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: batteryContainer.scale = 1.1
                onExited: batteryContainer.scale = 1.0
                onPressed: batteryContainer.scale = 0.95
                onReleased: batteryContainer.scale = 1.1
                onClicked: {
                  panelManager.togglePanel("battery")
                }
            }
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        Item { Layout.fillWidth: true }

        // Power Off
        Rectangle {
            id: powerContainer
            Layout.preferredWidth: powerIcon.width
            Layout.fillHeight: true
            color: "transparent"
            radius: 6
            transformOrigin: Item.Center

            Image {
                id: powerIcon
                source: '../../assets/system/poweroff.png'
                width: 30
                height: 30
                sourceSize: Qt.size(30, 30)
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onEntered: powerContainer.scale = 1.2
                onExited: powerContainer.scale = 1.0
                onPressed: powerContainer.scale = 0.9
                onReleased: powerContainer.scale = 1.2
                
                onClicked: {
                  panelManager.togglePanel("dashboard")
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }

    // =============================
    //   INITIALIZATION & TIMERS
    // =============================
    
    Component.onCompleted: {
        updateBatteryCappacityProcess()
        
        // Chạy battery status ngay lập tức
        if (!batteryStatusProcess.running) {
            batteryStatusProcess.running = true
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: updateBatteryCappacityProcess()
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            if (!batteryStatusProcess.running) {
                batteryStatusProcess.running = true
            }
        }
    }


}
