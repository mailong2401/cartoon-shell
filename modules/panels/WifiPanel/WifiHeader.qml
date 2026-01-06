import QtQuick
import QtQuick.Layouts

RowLayout {
    id: header
    property var theme
    property var lang
    property var wifiManager
    
    spacing: 20
    
    Rectangle {
        width: 70
        height: 70
        radius: 12
        color: "transparent"
        Image {
            source: "../../../assets/system/wifi.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            width: 50
            height: 50
            anchors.centerIn: parent
        }
    }
    
    Text {
        text: "WiFi"
        font.pixelSize: 50
        font.family: "ComicShannsMono Nerd Font"
        font.bold: true
        color: theme.primary.foreground
    }
    
    Item { Layout.fillWidth: true }
    
    // Nút refresh với icon search và hiệu ứng giống hệt Bluetooth
    Rectangle {
        id: scanButton
        Layout.preferredWidth: 55
        Layout.preferredHeight:55
        radius: 28
        visible: wifiManager.wifiEnabled || false
        color: {
            if (wifiManager.isScanning) return theme.normal.red
            if (scanButtonMouse.containsMouse) return theme.normal.blue
            return theme.primary.dim_background
        }

        scale: scanButtonMouse.containsPress ? 0.95 : (scanButtonMouse.containsMouse ? 1.1 : 1.0)
        Behavior on scale { 
            NumberAnimation { 
                duration: 200; 
                easing.type: Easing.OutCubic 
            } 
        }
        Behavior on color { 
            ColorAnimation { 
                duration: 200 
            } 
        }

        // Sử dụng icon search giống Bluetooth
        Image {
            source: "../../../assets/launcher/search.png"
            width: 40
            height: 40
            sourceSize: Qt.size(40, 40)
            anchors.centerIn: parent
        }

        // Animation khi đang quét mạng - giống hệt Bluetooth
        Rectangle {
            anchors.fill: parent
            radius: 28
            color: "transparent"
            border.width: 2
            border.color: theme.normal.green
            visible: wifiManager.isScanning
            rotation: scanRotation

            RotationAnimator on rotation {
                id: scanRotation
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: wifiManager.isScanning
            }

            Rectangle {
                width: 4
                height: 4
                radius: 2
                color: theme.normal.green
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: -2
            }
        }

        MouseArea {
            id: scanButtonMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (wifiManager.wifiEnabled) {
                    wifiManager.scanWifiNetworks()
                }
            }
        }
    }
}
