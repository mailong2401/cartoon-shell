import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.components

Rectangle {
    id: calendar

    property date currentDate: new Date()
    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()
    property date selectedDate: new Date()
    property real animationProgress: 0

    SequentialAnimation on animationProgress {
        running: true

        NumberAnimation {
            from: 0
            to: 0.4
            duration: 200
            easing.type: Easing.Linear
        }
    }

    width: ScalerService.s(350)
    height: ScalerService.s(350)
    color: "transparent"
    radius: ScalerService.s(10)

    property var weekdayLabels: {
        const w = lang?.calendar?.weekdays;
        return w ? [w.sunday || "CN", w.monday || "T2", w.tuesday || "T3", w.wednesday || "T4", w.thursday || "T5", w.friday || "T6", w.saturday || "T7"] : ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];
    }

    property var monthLabels: {
        const m = lang?.dateFormat?.month;
        return m ? [m.january || "Tháng 1", m.february || "Tháng 2", m.march || "Tháng 3", m.april || "Tháng 4", m.may || "Tháng 5", m.june || "Tháng 6", m.july || "Tháng 7", m.august || "Tháng 8", m.september || "Tháng 9", m.october || "Tháng 10", m.november || "Tháng 11", m.december || "Tháng 12"] : ["Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6", "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"];
    }

    signal dateSelected(date selectedDate)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: ScalerService.s(10)
        spacing: ScalerService.s(15)

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: ScalerService.s(12)

            ButtonIconText {
                name: "arrow_circle_left"
                opacity: calendar.animationProgress > 0.1 ? 1 : 0
                textColor: theme.normal.red
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
                onClicked: previousMonth()
            }
            ButtonIconText {
                name: "arrow_circle_right"
                opacity: calendar.animationProgress > 0.3 ? 1 : 0
                textColor: theme.normal.blue
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
                onClicked: nextMonth()
            }
            ButtonIconText {
                name: "explore_nearby"
                opacity: calendar.animationProgress > 0.3 ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
                onClicked: goToToday()
            }
            Item {
                Layout.fillWidth: true
            }

            CustomText {
                name: monthLabels[currentMonth] + " " + currentYear

                opacity: calendar.animationProgress > 0.2 ? 1 : 0
                textColor: theme.normal.magenta

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
                isBold: true
                size: "normal"
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }

        // Calendar grid với Flickable để cuộn
        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: calendarGrid.width
            contentHeight: calendarGrid.height
            clip: true

            GridLayout {
                id: calendarGrid
                width: flickable.width
                columns: 7
                rowSpacing: ScalerService.s(8)
                columnSpacing: ScalerService.s(8)

                // Week day headers
                Repeater {
                    model: weekdayLabels
                    CustomText {
                        opacity: 0

                        SequentialAnimation on opacity {
                            running: true

                            PauseAnimation {
                                duration: index * 50
                            }

                            NumberAnimation {
                                to: 1
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                        name: modelData
                        isBold: true
                        size: "small"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.preferredHeight: ScalerService.s(30)
                    }
                }

                // Days
                Repeater {
                    id: daysRepeater
                    model: getDaysInMonth(currentMonth, currentYear)

                    Rectangle {
                        id: dayRect
                        Layout.preferredWidth: ScalerService.s(40)
                        Layout.preferredHeight: ScalerService.s(40)

                        opacity: 0

                        SequentialAnimation on opacity {
                            running: true

                            PauseAnimation {
                                duration: index * 15
                            }

                            NumberAnimation {
                                to: 1
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                        color: {
                            if (modelData.isToday && modelData.isCurrentMonth)
                                return theme.button.text;
                            else
                                return "transparent";
                        }
                        radius: ScalerService.s(20)

                        CustomText {
                            name: modelData.day
                            anchors.centerIn: parent
                            size: "small"
                            textColor: {
                                if (!modelData.isCurrentMonth)
                                    return theme.primary.dim_foreground;
                                else if (modelData.isToday)
                                    return theme.button.background;
                                else
                                    return theme.button.text;
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (modelData.isCurrentMonth) {
                                    selectedDate = modelData.fullDate;
                                    calendar.dateSelected(selectedDate);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function getDaysInMonth(month, year) {
        var days = [];
        var firstDay = new Date(year, month, 1);
        var lastDay = new Date(year, month + 1, 0);
        var startingDay = firstDay.getDay();

        // Ngày từ tháng trước
        var prevMonthLastDay = new Date(year, month, 0).getDate();
        for (var i = 0; i < startingDay; i++) {
            days.push({
                day: prevMonthLastDay - startingDay + i + 1,
                isCurrentMonth: false,
                isToday: false,
                fullDate: new Date(year, month - 1, prevMonthLastDay - startingDay + i + 1)
            });
        }

        // Ngày của tháng hiện tại
        var today = new Date();
        for (var j = 1; j <= lastDay.getDate(); j++) {
            var isToday = today.getDate() === j && today.getMonth() === month && today.getFullYear() === year;
            days.push({
                day: j,
                isCurrentMonth: true,
                isToday: isToday,
                fullDate: new Date(year, month, j)
            });
        }

        // Ngày từ tháng sau
        var totalCells = 42;
        var nextMonthDay = 1;
        while (days.length < totalCells) {
            days.push({
                day: nextMonthDay,
                isCurrentMonth: false,
                isToday: false,
                fullDate: new Date(year, month + 1, nextMonthDay)
            });
            nextMonthDay++;
        }

        return days;
    }

    function previousMonth() {
        currentDate = new Date(currentYear, currentMonth - 1, 1);
        currentMonth = currentDate.getMonth();
        currentYear = currentDate.getFullYear();
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear);
    }

    function nextMonth() {
        currentDate = new Date(currentYear, currentMonth + 1, 1);
        currentMonth = currentDate.getMonth();
        currentYear = currentDate.getFullYear();
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear);
    }

    function goToToday() {
        currentDate = new Date();
        currentMonth = currentDate.getMonth();
        currentYear = currentDate.getFullYear();
        selectedDate = new Date();
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear);
    }

    Component.onCompleted: {
        daysRepeater.model = getDaysInMonth(currentMonth, currentYear);
    }
}
