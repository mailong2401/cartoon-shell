import QtQuick
import QtQuick.Layouts
import "." as Com

RowLayout {
    id: currentDisplay

    property var theme: currentTheme
    required property string temperature
    required property string condition
    required property string icon
    required property string feelsLike
    required property string humidity
    required property string windSpeed
    required property string pressure
    required property string visibility
    required property string uvIndex
    required property bool hasData

    spacing: 20

    // Main weather card - LEFT
    Rectangle {
        visible: currentDisplay.hasData
        Layout.preferredWidth: 200
        Layout.fillHeight: true
        radius: 16

        color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

              Image {
                    source: currentDisplay.icon
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 60
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false
                    smooth: true
                    mipmap: true
                }

            Text {
                text: currentDisplay.temperature
                color: theme.primary.foreground
                font {
                    pixelSize: 48
                    bold: true
                    family: "ComicShannsMono Nerd Font"
                }
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: currentDisplay.condition
                color: theme.primary.foreground
                font {
                    pixelSize: 18
                    family: "ComicShannsMono Nerd Font"
                }
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Item { Layout.fillHeight: true }
        }
    }

    // Weather details grid - 3x2 layout - RIGHT
    GridLayout {
        visible: currentDisplay.hasData
        Layout.fillWidth: true
        Layout.fillHeight: true
        columns: 3
        columnSpacing: 5
        rowSpacing: 5

        // Humidity
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: "../../../assets/weather/humidity.png"
            value: currentDisplay.humidity
        }

        // Wind Speed
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: currentConfig.theme === "light"
        ? "../../../assets/weather/wind_light.png"
        : "../../../assets/weather/wind_dark.png"
            value: currentDisplay.windSpeed
        }

        // Pressure
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: "../../../assets/weather/pressure.png"
            value: currentDisplay.pressure
        }

        // Visibility
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: "../../../assets/weather/visibility.png"
            value: currentDisplay.visibility
        }

        // UV Index
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: currentConfig.theme === "light"
        ? "../../../assets/weather/uv_light.png"
        : "../../../assets/weather/uv_dark.png"
            value: currentDisplay.uvIndex
        }

        // Feels Like
        Com.WeatherDetailCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            image: currentConfig.theme === "light"
        ? "../../../assets/weather/feels_like_light.png"
        : "../../../assets/weather/feels_like_dark.png"
            value: currentDisplay.feelsLike
        }
    }
}
