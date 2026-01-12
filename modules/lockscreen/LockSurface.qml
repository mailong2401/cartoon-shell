import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Qt5Compat.GraphicalEffects
import Quickshell.Wayland
import Quickshell.Services.Mpris
import Quickshell.Io

Rectangle {
    id: root
    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    property var theme: currentTheme
    property string backgroundImagePath: "/home/long/Pictures/Wallpapers/slide_4.jpg"

    // MPRIS: Binding trực tiếp, tự động cập nhật khi player thay đổi
    

    // Volume state
    property real currentVolume: 0.5
    property bool isMuted: false

    // Battery state
    property real batteryPercentage: 0
    property bool batteryCharging: false

    // Brightness state
    property real currentBrightness: 0.5

    // Animation state
    property bool lockIconAnimationComplete: false

    color: theme.primary.dim_background

    // --- CÁC PROCESS TĨNH ---
    Process {
        id: setVolumeProcess
        command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+0%"]
        running: false
        onExited: getVolumeProcess.running = true

        function set(val) {
            command = ["pactl", "set-sink-volume", "@DEFAULT_SINK@", val]
            running = true
        }
    }

    Process {
        id: toggleMuteProcess
        command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"]
        running: false
        onExited: getMuteProcess.running = true
    }

    Process {
        id: setBrightnessProcess
        command: ["brightnessctl", "set", "50%"]
        running: false
        onExited: getCurrentBrightnessProcess.running = true

        function set(val) {
            command = ["brightnessctl", "set", val]
            running = true
        }
    }

    // Timer cập nhật volume
    Timer {
        running: true; repeat: true; interval: 2000
        onTriggered: getVolumeProcess.running = true
    }

    Process {
        id: getVolumeProcess
        command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                const match = data.match(/(\d+)%/);
                if (match) root.currentVolume = parseInt(match[1]) / 100.0;
            }
        }
    }

    Process {
        id: getMuteProcess
        command: ["pactl", "get-sink-mute", "@DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => root.isMuted = data.includes("yes")
        }
    }

    // Timer cập nhật battery
    Timer {
        running: true; repeat: true; interval: 10000
        onTriggered: {
            getBatteryProcess.running = true;
            getBatteryChargingProcess.running = true;
        }
    }

    Process {
        id: getBatteryProcess
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 100"]
        stdout: SplitParser {
            onRead: data => {
                const match = data.trim().match(/\d+/);
                if (match) root.batteryPercentage = parseInt(match[0]) / 100.0;
            }
        }
    }

    Process {
        id: getBatteryChargingProcess
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo Discharging"]
        stdout: SplitParser {
            onRead: data => root.batteryCharging = data.trim() === "Charging"
        }
    }

    // Timer cập nhật brightness
    Timer {
        running: true; repeat: true; interval: 2000
        onTriggered: getCurrentBrightnessProcess.running = true
    }

    Process {
        id: getCurrentBrightnessProcess
        command: ["sh", "-c", "echo $(brightnessctl g 2>/dev/null || echo 128)/$(brightnessctl m 2>/dev/null || echo 255) | bc -l"]
        stdout: SplitParser {
            onRead: data => {
                const brightness = parseFloat(data.trim());
                if (!isNaN(brightness)) root.currentBrightness = Math.max(0, Math.min(1, brightness));
            }
        }
    }

    Component.onCompleted: {
        getVolumeProcess.running = true;
        getMuteProcess.running = true;
        getBatteryProcess.running = true;
        getBatteryChargingProcess.running = true;
        getCurrentBrightnessProcess.running = true;
    }

    // Background gradient
    gradient: Gradient {
        GradientStop { position: 0.0; color: theme.primary.dim_background }
        GradientStop { position: 0.5; color: theme.primary.background }
        GradientStop { position: 1.0; color: theme.primary.dim_background }
    }

    // Background image with blur
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: root.backgroundImagePath
        fillMode: Image.PreserveAspectCrop
        visible: false
        asynchronous: true
        cache: true
    }

    FastBlur {
        id: blurEffect
        anchors.fill: parent
        source: backgroundImage
        radius: 64
        visible: root.backgroundImagePath !== ""
        opacity: 1
        cached: true

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.4
        }
    }

    // --- LOCK ICON ANIMATION ---
    Rectangle {
        id: lockIconContainer
        anchors.centerIn: parent
        width: 180
        height: 180
        radius: 28
        color: "transparent"
        opacity: 0
        scale: 0.8

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: theme.primary.foreground
            opacity: 0.08
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 2
            border.color: theme.primary.foreground
            opacity: 0.25
        }

        Text {
            id: lockIcon
            color: theme.primary.foreground
            anchors.centerIn: parent
            text: "󰌾"
            font.pixelSize: 80
        }

        SequentialAnimation {
            running: true
            ParallelAnimation {
                NumberAnimation {
                    target: lockIconContainer
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 600
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: lockIconContainer
                    property: "scale"
                    from: 0.8
                    to: 1
                    duration: 600
                    easing.type: Easing.OutBack
                }
            }
            PauseAnimation { duration: 300 }
            NumberAnimation {
                target: lockIcon
                property: "rotation"
                from: 0
                to: 360
                duration: 800
                easing.type: Easing.OutCubic
            }
            PauseAnimation { duration: 200 }
            ParallelAnimation {
                NumberAnimation {
                    target: lockIconContainer
                    property: "scale"
                    to: 0.6
                    duration: 400
                    easing.type: Easing.InBack
                }
                NumberAnimation {
                    target: lockIconContainer
                    property: "opacity"
                    to: 0
                    duration: 400
                    easing.type: Easing.InCubic
                }
            }
            ScriptAction {
                script: root.lockIconAnimationComplete = true
            }
        }
    }

    // --- DASHBOARD PANEL ---
    DashboardPanel {
        id: dashboardPanel
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: passwordSection.top
            bottomMargin: 50
        }
        width: 1200
        height: 600
        opacity: 1
        visible: root.lockIconAnimationComplete

        // Pass data from root
        isMuted: root.isMuted
        batteryPercentage: root.batteryPercentage
        batteryCharging: root.batteryCharging
    }

    // --- PASSWORD INPUT ---
    Item {
        id: passwordSection
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 50
        }
        width: 450; height: 200
        opacity: 1
        visible: root.lockIconAnimationComplete

        Label {
            anchors { horizontalCenter: parent.horizontalCenter; bottom: passwordContainer.top; bottomMargin: 15 }
            text: "What's password?"
            color: theme.primary.foreground
            opacity: 0.9
            font.pointSize: 11
            style: Text.Outline
            styleColor: theme.primary.dim_background
        }

        Rectangle {
            id: passwordContainer
            anchors.centerIn: parent
            width: 450
            height: 65
            radius: 16
            color: "transparent"
            border.color: root.context.showFailure ? theme.normal.red : (passwordBox.focus ? theme.primary.foreground : theme.primary.dim_foreground)
            border.width: 2

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: theme.primary.foreground
                opacity: 0.1
            }

            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
            Behavior on border.color { ColorAnimation { duration: 200 } }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                radius: parent.radius + 2
                color: "transparent"
                border.color: passwordBox.focus ? theme.primary.foreground : "transparent"
                border.width: 2
                opacity: 0.3
                visible: passwordBox.focus
            }

            Row {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                Rectangle {
                    width: 35
                    height: 35
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 8
                    color: "transparent"
                    border.color: theme.primary.foreground
                    border.width: 1

                    Text {
                        color: theme.primary.foreground
                        anchors.centerIn: parent
                        text: root.context.unlockInProgress ? "󰩈" : "󰌾"
                        font.pixelSize: 20
                    }
                }

                TextField {
                    id: passwordBox
                    width: parent.width - 110
                    height: parent.height
                    background: Rectangle { color: "transparent" }
                    color: theme.primary.foreground
                    font.pixelSize: 18
                    verticalAlignment: TextInput.AlignVCenter
                    placeholderText: "Tell me your password:33"
                    placeholderTextColor: theme.primary.dim_foreground
                    focus: true
                    enabled: !root.context.unlockInProgress
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhSensitiveData

                    onTextChanged: {
                        root.context.currentText = this.text;
                        passwordContainer.scale = 1.03;
                        scaleResetTimer.restart();
                    }
                    onAccepted: root.context.tryUnlock();

                    Timer {
                        id: scaleResetTimer
                        interval: 100
                        onTriggered: passwordContainer.scale = 1.0
                    }

                    Connections {
                        target: root.context
                        function onCurrentTextChanged() {
                            passwordBox.text = root.context.currentText;
                        }
                    }
                }

                Rectangle {
                    width: 50
                    height: 35
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 8
                    color: !root.context.unlockInProgress && root.context.currentText !== "" ? theme.normal.blue : "transparent"
                    border.color: theme.primary.foreground
                    border.width: !root.context.unlockInProgress && root.context.currentText !== "" ? 0 : 1
                    scale: unlockMouseArea.containsMouse ? 1.1 : 1.0

                    Behavior on scale { NumberAnimation { duration: 150 } }
                    Behavior on color { ColorAnimation { duration: 200 } }

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        font.pixelSize: 24
                        font.bold: true
                        color: theme.primary.foreground
                        rotation: root.context.unlockInProgress ? 360 : 0
                        Behavior on rotation { NumberAnimation { duration: 500 } }
                    }

                    MouseArea {
                        id: unlockMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !root.context.unlockInProgress && root.context.currentText !== ""
                        onClicked: root.context.tryUnlock()
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
            }
        }

        Rectangle {
            anchors { horizontalCenter: parent.horizontalCenter; top: passwordContainer.bottom; topMargin: 20 }
            width: errorLabel.width + 30
            height: 40
            radius: 12
            color: theme.normal.red
            visible: root.context.showFailure
            opacity: root.context.showFailure ? 1 : 0
            scale: root.context.showFailure ? 1 : 0.8

            Behavior on opacity { NumberAnimation { duration: 200 } }
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

            SequentialAnimation on x {
                running: root.context.showFailure
                NumberAnimation { to: 5; duration: 50 }
                NumberAnimation { to: -5; duration: 50 }
                NumberAnimation { to: 3; duration: 50 }
                NumberAnimation { to: -3; duration: 50 }
                NumberAnimation { to: 0; duration: 50 }
            }

            Label {
                id: errorLabel
                anchors.centerIn: parent
                text: "✕ Nah that's not your password!"
                color: theme.primary.background
                font.pointSize: 10
                font.bold: true
            }
        }
    }
}
