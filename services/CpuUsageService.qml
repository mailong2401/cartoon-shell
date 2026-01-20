import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    
    property string cpuUsage: "0%"
    
    Process {
        id: cpuProcess
        
        command: [
            "bash", 
            "-c", 
            "vmstat 1 2 | tail -1 | awk '{printf \"%.1f\", 100 - $15}'"
        ]
        
        stdout: StdioCollector {
            onTextChanged: {
                if (text && text.trim() !== "") {
                    try {
                        const usage = parseFloat(text.trim())
                        if (!isNaN(usage)) {
                            // Smooth transition
                            root.cpuUsage = Math.round(usage) + "%"
                        }
                    } catch (e) {
                        console.warn("Failed to parse CPU:", text)
                    }
                }
            }
        }
        

    }
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        
        onTriggered: {
            if (!cpuProcess.running) {
                cpuProcess.running = true
            }
        }
    }
}
