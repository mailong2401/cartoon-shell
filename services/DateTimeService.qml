import QtQuick
import Quickshell

Item {
    id: root
    
    property var lang: currentLanguage
    property string currentDate: ""
    property string currentTime: ""
    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        onDateChanged: {
            updateDateTime()
        }
    }
    function updateDateTime() {
        const now = clock.date
        const weekdayData = lang?.calendar?.weekdays
        const weekdays = weekdayData ? [
            weekdayData.sunday || "CN",
            weekdayData.monday || "T2",
            weekdayData.tuesday || "T3",
            weekdayData.wednesday || "T4",
            weekdayData.thursday || "T5",
            weekdayData.friday || "T6",
            weekdayData.saturday || "T7"
        ] : ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
        const monthData = lang?.dateFormat?.month
        const months = monthData ? [
            monthData.january || "Th1",
            monthData.february || "Th2",
            monthData.march || "Th3",
            monthData.april || "Th4",
            monthData.may || "Th5",
            monthData.june || "Th6",
            monthData.july || "Th7",
            monthData.august || "Th8",
            monthData.september || "Th9",
            monthData.october || "Th10",
            monthData.november || "Th11",
            monthData.december || "Th12"
        ] : ["Th1", "Th2", "Th3", "Th4", "Th5", "Th6", "Th7", "Th8", "Th9", "Th10", "Th11", "Th12"]

        root.currentDate = `${weekdays[now.getDay()]}, ${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`
        root.currentTime = Qt.formatTime(now, "HH:mm")
    }
    
    Component.onCompleted: {
        updateDateTime()
    }
}
