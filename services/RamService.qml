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
            "free -h | awk '/Mem:/ {gsub(/Gi/,\"\",$3); printf \"%d\\n\", $3}'"
        ]

        stdout: StdioCollector {
            onTextChanged: {
                const value = parseInt(text.trim())
                if (!isNaN(value)) {
                    root.ramUsed = value
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

