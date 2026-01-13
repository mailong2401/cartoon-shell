import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell

Rectangle {
    id: root

    property var sizes: currentSizes
    property var theme: currentTheme
    property var lang: currentLanguage
    property string currentHour: ""
    property string currentMin: ""
    property string currentDay: ""
    property string currentDate: ""

    Layout.fillWidth: true
    Layout.preferredHeight: 120
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.normal.black

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        onDateChanged: {
            updateDateTime()
        }
    }

    function updateDateTime() {
        const now = new Date()
        const dayData = lang?.dateFormat?.day
        const weekdays = dayData ? [
            dayData.sunday || "Sun",
            dayData.monday || "Mon",
            dayData.tuesday || "Tue",
            dayData.wednesday || "Wed",
            dayData.thursday || "Thu",
            dayData.friday || "Fri",
            dayData.saturday || "Sat"
        ] : ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

        const monthData = lang?.dateFormat?.month
        const months = monthData ? [
            monthData.january || "Jan",
            monthData.february || "Feb",
            monthData.march || "Mar",
            monthData.april || "Apr",
            monthData.may || "May",
            monthData.june || "Jun",
            monthData.july || "Jul",
            monthData.august || "Aug",
            monthData.september || "Sep",
            monthData.october || "Oct",
            monthData.november || "Nov",
            monthData.december || "Dec"
        ] : ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        root.currentDay = `${weekdays[now.getDay()]}`
        root.currentHour = Qt.formatTime(now, "HH")
        root.currentMin = Qt.formatTime(now, "mm")
        root.currentDate = `${now.getDate()} ${months[now.getMonth()]} ${now.getFullYear()}`
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Phần hiển thị thời gian (giờ và phút)
        ColumnLayout {
            spacing: 2
            Text {
                text: root.currentHour
                color: theme.primary.foreground
                font {
                    pixelSize: 30
                    bold: true
                    family: "ComicShannsMono Nerd Font"
                }
            }

            Text {
                text: root.currentMin
                color: theme.primary.foreground
                font {
                    pixelSize: 30
                    bold: true
                    family: "ComicShannsMono Nerd Font"
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 4
            Layout.preferredHeight: 90
            color: theme.primary.foreground
            radius: 2
        }

        // Phần hiển thị ngày tháng
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: root.currentDay
                color: theme.primary.foreground
                font {
                    pixelSize: 24
                    bold: true
                    family: "ComicShannsMono Nerd Font"
                }
            }
            Text {
                text: root.currentDate
                color: theme.primary.foreground
                font {
                    pixelSize: 14
                    bold: true
                    family: "ComicShannsMono Nerd Font"
                }
            }
        }
    }

    Component.onCompleted: {
        root.updateDateTime()
    }
}
