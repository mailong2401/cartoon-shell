import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    // ===== Public API =====
    property int ramUsed: 0

    // ===== Internal =====
    Process {
    id: ramProcess

    command: [
        "bash",
        "-c",
        "awk '/MemTotal/{t=$2}/MemFree/{f=$2}/Buffers/{b=$2}/^Cached:/{c=$2} END{print int(((t-f-b-c)/t)*100)}' /proc/meminfo"
    ]

    stdout: StdioCollector {
        onTextChanged: {
            const value = parseInt(text.trim())
            if (!isNaN(value)) {
                root.ramUsed = value   // %
            }
        }
    }
}



    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            if (!ramProcess.running) {
                ramProcess.running = true
            }
        }
    }
}

