import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./WeatherTime/" as WeatherTime

Rectangle {
    id: root
    color: theme.primary.background
    radius: 10
    border.color: theme.button.border
    border.width: 3


    property var lang: currentLanguage
    property string currentDate: ""
    property string currentTime: ""
    property string temperature: "..."
    property string condition: "Đang tải"
    property string icon: "⏳"
    property string humidity: ""
    property string feelsLike: ""
    property bool panelVisible: false
    property bool flagPanelVisible: false
    property bool weatherPanelVisible: false
    property string selectedFlag: currentConfig.countryFlag
    property string weatherApiKey: currentConfig.weatherApiKey
    property string weatherLocation: currentConfig.weatherLocation || "Ho Chi Minh,VN"
    property var theme : currentTheme

    // SystemClock để lấy thời gian thực
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
        onDateChanged: {
            updateDateTime()
        }
    }

    // Process lấy weather
    Process {
        id: weatherProcess
        command: ["curl", "-s", `https://api.weatherapi.com/v1/current.json?key=${root.weatherApiKey}&q=${root.weatherLocation.replace(/ /g, '%20')}&lang=${currentConfig.lang}`]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (text && text.length > 0 && root.weatherApiKey !== "") {
                    const parsed = JSON.parse(text)
                    root.processWeatherData(parsed)
                } else if (root.weatherApiKey === "") {
                    root.temperature = "No API"
                    root.condition = "Chưa có API key"
                } else {
                    root.temperature = "Lỗi"
                    root.condition = "Không có dữ liệu"
                }
            }
        }
    }

    function processWeatherData(data) {
        if (data.current) {
            root.temperature = `${Math.round(data.current.temp_c)}°C`
            root.condition = data.current.condition.text
            root.humidity = `${data.current.humidity}%`
            root.feelsLike = `${Math.round(data.current.feelslike_c)}°C`
            root.icon = root.getWeatherIcon(data.current.condition.code, data.current.is_day)
        }
    }

    function getWeatherIcon(code, isDay) {
    code = Number(code)

    const basePath =
        root.theme?.type === "dark"
            ? "../../assets/weather/dark"
            : "../../assets/weather/light"

    // 1000: Sunny / Clear
    if (code === 1000)
        return isDay
            ? `${basePath}/sunny.png`
            : `${basePath}/night.png`

    // 1003: Partly cloudy
    if (code === 1003)
        return isDay
            ? `${basePath}/partly_cloudy_day.png`
            : `${basePath}/partly_cloudy_night.png`

    // 1006, 1009: Cloudy / Overcast
    if ([1006, 1009].includes(code))
        return `${basePath}/cloud.png`

    // 1030, 1135, 1147: Mist / Fog
    if ([1030, 1135, 1147].includes(code))
        return `${basePath}/fog.png`

    // 🌧️ Rain / Drizzle / Freezing rain
    if ((code >= 1063 && code <= 1195) || (code >= 1198 && code <= 1201))
        return `${basePath}/rain.png`

    // 🌨️ Snow / Sleet / Ice pellets
    if (code >= 1204 && code <= 1264)
        return `${basePath}/snowy.png`

    // ⛈️ Thunderstorm
    if (code >= 1273 && code <= 1282)
        return `${basePath}/thunder.png`

    // 🌈 Fallback
    return `${basePath}/rainbow.png`
}



    function updateWeather() {
        if (root.weatherApiKey === "" || root.weatherApiKey === undefined) {
            root.temperature = "No API"
            root.condition = "Chưa có key"
            return
        }
        if (!weatherProcess.running) {
            weatherProcess.running = true
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

    RowLayout {
            anchors.fill: parent
    anchors {
        leftMargin: 10
        rightMargin: 10
        topMargin: 5
        bottomMargin: 5
    }
    spacing: 5


        // Phần datetime - căn trái
        Item {
            id: timeContainer
            Layout.preferredWidth: textCurrentDate.implicitWidth + 20
            Layout.fillHeight: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 0
                Text {
                    text: root.currentTime
                    color: root.theme.primary.foreground
                    font {
                        pixelSize: 16
                        bold: true
                        family: "ComicShannsMono Nerd Font"
                    }
                }

                Text {
                    id: textCurrentDate
                    text: root.currentDate
                    color: root.theme.primary.dim_foreground
                    font.pixelSize: 13
                    font.family: "ComicShannsMono Nerd Font"
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("calendar")
                }
                
                // Hiệu ứng hover
                onEntered: {
                    timeContainer.scale = 1.04
                }
                onExited: {
                    timeContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Spacer để đẩy phần giữa ra chính giữa
        Item {
            Layout.fillWidth: true
        }

        // Phần weather - căn giữa
        Item {
            id: weatherContainer
            Layout.preferredWidth: contentWeather.implicitWidth
            Layout.fillHeight: true

            RowLayout {
                id: contentWeather
                anchors.centerIn: parent

                ColumnLayout {
                    spacing: 1
                    Text {
                        text: root.temperature || "Đang tải..."
                        color: root.theme.primary.foreground
                        Layout.alignment: Qt.AlignVCenter
                        font {
                            pixelSize: 16
                            bold: true
                            family: "ComicShannsMono Nerd Font"
                        }
                    }
                    
                    Text {
                        id: textCondition
                        text: root.condition || "..."
                        color: root.theme.primary.dim_foreground
                        font {
                            pixelSize: 11
                            family: "ComicShannsMono Nerd Font"
                        }
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        Layout.preferredWidth: 80
                    }
                }
                
                Image {
                    source: root.icon
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false
                    smooth: true
                    mipmap: true
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("weather")
                }
                
                onEntered: {
                    weatherContainer.scale = 1.04
                }
                onExited: {
                    weatherContainer.scale = 1.0
                }
            }
            
            Behavior on scale { NumberAnimation { duration: 100 } }
        }

        // Spacer để đẩy phần flag sang bên phải
        Item {
            Layout.fillWidth: true
        }

        // Flag Selector - căn phải
        Item {
            id: flagContainer
            Layout.preferredWidth: 50
            Layout.fillHeight: parent

            Image {
                source: root.selectedFlag ? `../../assets/flags/${root.selectedFlag}.png` : ""
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                smooth: true
                anchors.centerIn: parent
                visible: root.selectedFlag !== ""
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    panelManager.togglePanel("flag")
                }

                onEntered: {
                    flagContainer.scale = 1.1
                }
                onExited: {
                    flagContainer.scale = 1.0
                }
            }

            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }

    // Timer cho weather (giữ nguyên)
    Timer {
        interval: 50000 // 5 phút
        running: true
        repeat: true
        onTriggered: root.updateWeather()
    }
    Timer {
        id: initialLoadTimer
        interval: 100
        running: true
        repeat: false
        onTriggered: root.updateWeather()
    }

    Component.onCompleted: {
        root.updateDateTime() // Khởi tạo thời gian ban đầu
        root.updateWeather()
    }
}
