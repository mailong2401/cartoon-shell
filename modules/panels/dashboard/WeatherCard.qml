import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Io
import "../../../services" as Services

Rectangle {
    id: root
    property var theme: currentTheme
    property var sizes: currentSizes
    property string apiKey: ""
    property string location: ""
    property string temperature: ""
    property string condition: ""
    property string icon: "⛅"
    property var forecastDays: []
    property bool isLoading: false
    property string errorMessage: ""

    Layout.preferredWidth: 400
    Layout.preferredHeight: 240
    radius: 28
    color: theme.primary.background
    border.width: 3
    border.color: theme.button.border

    Services.JsonEditor {
        id: weatherConfig
        filePath: Qt.resolvedUrl("../../../config/configs/" + currentConfigProfile + ".json")
        Component.onCompleted: {
            weatherConfig.load(weatherConfig.filePath)
            root.apiKey = weatherConfig.get("weatherApiKey", "")
            root.location = weatherConfig.get("weatherLocation", "Ho Chi Minh,VN")
            if (root.apiKey !== "") {
                root.updateWeather()
            }
        }
    }

    // Process lấy weather forecast
    Process {
        id: weatherProcess
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.isLoading = false
                if (text && text.length > 0) {
                    try {
                        const data = JSON.parse(text)
                        if (data.error) {
                            root.errorMessage = data.error.message
                        } else {
                            root.processWeatherData(data)
                            root.errorMessage = ""
                        }
                    } catch(e) {
                        root.errorMessage = "Cannot parse weather data"
                    }
                }
            }
        }
    }

    function processWeatherData(data) {
        if (data.current) {
            temperature = `${Math.round(data.current.temp_c)}°C`
            condition = data.current.condition.text
            icon = getWeatherIcon(data.current.condition.code, data.current.is_day)
        }

        if (data.forecast && data.forecast.forecastday) {
            const forecast = []
            for (let i = 0; i < Math.min(3, data.forecast.forecastday.length); i++) {
                const day = data.forecast.forecastday[i]
                forecast.push({
                    date: day.date,
                    dateText: formatDate(day.date),
                    dayName: getDayName(day.date),
                    maxTemp: Math.round(day.day.maxtemp_c),
                    minTemp: Math.round(day.day.mintemp_c),
                    condition: day.day.condition.text,
                    icon: getWeatherIcon(day.day.condition.code, true),
                    rainChance: day.day.daily_chance_of_rain
                })
            }
            forecastDays = forecast
        }
    }

    function formatDate(dateStr) {
        const date = new Date(dateStr)
        return `${date.getDate()}/${date.getMonth() + 1}`
    }

    function getDayName(dateStr) {
        const date = new Date(dateStr)
        const today = new Date()
        const tomorrow = new Date(today)
        tomorrow.setDate(tomorrow.getDate() + 1)

        if (date.toDateString() === today.toDateString()) return currentLanguage?.dateFormat?.today || "Today"
        if (date.toDateString() === tomorrow.toDateString()) return currentLanguage?.dateFormat?.tomorrow || "Tomorrow"

        const weekdays = currentLanguage?.dateFormat?.day
        const days = weekdays ? [
            weekdays.sunday || "Sun", weekdays.monday || "Mon", weekdays.tuesday || "Tue",
            weekdays.wednesday || "Wed", weekdays.thursday || "Thu",
            weekdays.friday || "Fri", weekdays.saturday || "Sat"
        ] : ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return days[date.getDay()]
    }

    function getWeatherIcon(code, isDay) {
        const iconMap = {
            "1000": isDay ? "☀️" : "🌙", "1003": isDay ? "⛅" : "☁️", "1006": "☁️",
            "1009": "🌫️", "1030": "🌫️", "1063": "🌦️", "1066": "🌨️", "1087": "⛈️",
            "1183": "🌧️", "1186": "🌧️", "1273": "⛈️", "1276": "⛈️", "1279": "⛈️", "1282": "⛈️"
        }
        return iconMap[code.toString()] || "🌈"
    }

    function updateWeather() {
        if (apiKey === "") {
            errorMessage = "Please enter API key"
            return
        }
        isLoading = true
        errorMessage = ""
        const url = `https://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${encodeURIComponent(location)}&days=3&lang=${currentConfig.lang}`
        weatherProcess.command = ["curl", "-s", url]
        weatherProcess.running = true
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        // Current weather display
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Text {
                text: root.icon
                font.pixelSize: 60
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5

                Text {
                    text: root.temperature || "Loading..."
                    color: theme.primary.foreground
                    font.pixelSize: 36
                    font.bold: true
                    font.family: "ComicShannsMono Nerd Font"
                }

                Text {
                    text: root.condition || ""
                    color: theme.primary.foreground
                    font.pixelSize: 14
                    font.family: "ComicShannsMono Nerd Font"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }

        // Forecast row - horizontal layout
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            Repeater {
                model: root.forecastDays

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
                    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        // Day name
                        Text {
                            text: modelData.dayName
                            color: theme.primary.foreground
                            font {
                                pixelSize: sizes.fontSize?.medium || 16
                                bold: index === 0
                                family: "ComicShannsMono Nerd Font"
                            }
                            Layout.alignment: Qt.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // Weather icon
                        Text {
                            text: modelData.icon
                            font.pixelSize: 28
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Temperature range
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 2

                            Text {
                                text: `${modelData.minTemp}°`
                                color: theme.normal.cyan
                                font {
                                    pixelSize: sizes.fontSize?.medium || 16
                                    bold: true
                                    family: "ComicShannsMono Nerd Font"
                                }
                            }

                            Text {
                                text: "/"
                                color: theme.primary.dim_foreground
                                font.pixelSize: sizes.fontSize?.medium || 16
                            }

                            Text {
                                text: `${modelData.maxTemp}°`
                                color: theme.normal.red
                                font {
                                    pixelSize: sizes.fontSize?.medium || 16
                                    family: "ComicShannsMono Nerd Font"
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
    }
}
