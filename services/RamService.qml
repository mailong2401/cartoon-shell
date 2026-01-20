import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    // ===== Public API =====
    property int memPercent: 0              // Percentage
    property int memUsed: 0
    property int memTotal: 0             // MB
    property int memFree: 0              // MB
    property int buffers: 0              // MB
    property int cached: 0               // MB
    property int shmem: 0                // MB
    property int swapTotal: 0            // MB
    property int swapFree: 0             // MB
    property int swapUsed: 0             // Percentage (calculated)
    property int swapPercent: 0
    
    // ===== Control property =====
    property bool useSimpleCalculation: true  // true: dùng ramProcess, false: dùng meminfoProcess

    // ===== Internal =====
    Process {
        id: ramProcess
        running: useSimpleCalculation

        command: [
            "bash",
            "-c",
            "awk '/MemTotal/{t=$2}/MemFree/{f=$2}/Buffers/{b=$2}/^Cached:/{c=$2} END{print int(((t-f-b-c)/t)*100)}' /proc/meminfo"
        ]

        stdout: StdioCollector {
            onTextChanged: {
                const value = parseInt(text.trim())
                if (!isNaN(value)) {
                    root.memPercent = value   // %
                }
            }
        }
    }

    Process {
        id: meminfoProcess
        running: !useSimpleCalculation

        command: [
            "bash",
            "-c",
            "grep -E 'MemTotal|MemFree|Buffers|Cached|Shmem|SwapTotal|SwapFree' /proc/meminfo"
        ]

        stdout: StdioCollector {
            onTextChanged: {
                const lines = text.trim().split("\n")
                for (const line of lines) {
                    const parts = line.replace("kB", "").split(":")
                    const key = parts[0].trim()
                    const value = parseInt(parts[1].trim())

                    switch (key) {
                    case "MemTotal": 
                        memTotal = value
                        root.memTotal = Math.floor(value / 1024)
                        break
                    case "MemFree": 
                        memFree = value
                        root.memFree = Math.floor(value / 1024)
                        break
                    case "Buffers": 
                        buffers = value
                        root.buffers = Math.floor(value / 1024)
                        break
                    case "Cached": 
                        cached = value
                        root.cached = Math.floor(value / 1024)
                        break
                    case "Shmem": 
                        root.shmem = Math.floor(value / 1024)
                        break
                    case "SwapTotal": 
                        swapTotal = value
                        root.swapTotal = Math.floor(value / 1024)
                        break
                    case "SwapFree": 
                        swapFree = value
                        root.swapFree = Math.floor(value / 1024)
                        break
                    }
                }
                
                // Tính toán swapUsed dựa trên các giá trị đã có
                if (swapTotal > 0 && swapFree > 0) {
                    root.swapUsed = swapTotal - swapFree
                    root.swapPercent =Math.round((swapUsed / swapTotal) * 100)
                }
                
                // Tính toán menPercent dựa trên các giá trị đã có
                // Công thức tương tự như trong ramProcess: (MemTotal - MemFree - Buffers - Cached) / MemTotal * 100
                if (memTotal > 0 && memFree >= 0 && buffers >= 0 && cached >= 0) {
                    root.memUsed = memTotal - memFree - buffers - cached
                    root.memPercent = Math.round((root.memUsed / memTotal) * 100)
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
            if (useSimpleCalculation && !ramProcess.running) {
                ramProcess.running = true
                meminfoProcess.running = false
            } else if (!useSimpleCalculation && !meminfoProcess.running) {
                meminfoProcess.running = true
                ramProcess.running = false
            }
        }
    }

    // Cập nhật khi property useSimpleCalculation thay đổi
    onUseSimpleCalculationChanged: {
        if (useSimpleCalculation) {
            ramProcess.running = true
            meminfoProcess.running = false
        } else {
            meminfoProcess.running = true
            ramProcess.running = false
        }
    }
}
