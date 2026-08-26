pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int diskPercents: 0

    Process {
        id: diskProccess
        running: false
        command: ["df", "/", "--output=pcent"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");

                if (lines.length > 1) {
                    const value = lines[1].replace("%", "").trim();
                    root.diskPercents = parseInt(value);
                }
            }
        }
    }

    Timer {
        id: diskTimer
        interval: 2000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            if (!diskProccess.running) {
                diskProccess.running = true;
            }
        }
    }
}
