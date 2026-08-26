import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Io
import qs.services
import qs.components
import qs.commons

Item {
    id: root
    property real animationProgress: 0

    Layout.preferredWidth: ScalerService.s(400)
    Layout.preferredHeight: ScalerService.s(240)

    clip: true
    function getDayName(dateString) {
        var date = new Date(dateString);
        const dayData = lang?.dateFormat?.day;
        const days = dayData ? [dayData.sunday || "Sunday", dayData.monday || "Monday", dayData.tuesday || "Tuesday", dayData.wednesday || "Wednesday", dayData.thursday || "Thursday", dayData.friday || "Friday", dayData.saturday || "Saturday"] : ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        return days[date.getDay()];
    }

    Rectangle {
        anchors.centerIn: parent
        implicitWidth: root.animationProgress > 0.35 ? parent.width : 0
        implicitHeight: root.animationProgress > 0.35 ? parent.height : 0
        clip: true
        Behavior on implicitHeight {
            NumberAnimation {
                id: heightAnim
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
        Behavior on implicitWidth {
            NumberAnimation {
                id: widthAnim
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
        Loader {
            anchors.fill: parent

            active: !heightAnim.running && !widthAnim.running

            sourceComponent: FloatingCircles {
                circleColor: theme.button.text
                anchors.fill: parent
                circleCount: 2
            }
        }
        radius: ScalerService.s(Settings.appearance.radius1)
        border.width: Settings.appearance.enableBorder ? ScalerService.s(3) : 0
        border.color: theme.button.border
        color: theme.primary.background

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: ScalerService.s(20)
            spacing: ScalerService.s(12)

            // Current weather display
            RowLayout {
                Layout.fillWidth: true
                spacing: ScalerService.s(15)
                Layout.alignment: Qt.AlignHCenter

                IconImage {
                    path: WeatherService.getWeatherIcon(WeatherService.dataModel.current.condition.code, WeatherService.dataModel.current.is_day)
                    size: "xl"
                    opacity: root.animationProgress > 0.75 ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: ScalerService.s(5)

                    CustomText {
                        name: `${WeatherService.dataModel.current.temp_c}°C` || "Đang tải..."
                        Layout.alignment: Qt.AlignVCenter
                        size: "large"
                        isBold: true
                        opacity: root.animationProgress > 0.77 ? 1 : 0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }
                    CustomText {
                        id: textCondition

                        name: WeatherService.dataModel.current.condition.text.slice(0, 15) || "..."
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        opacity: root.animationProgress > 0.8 ? 1 : 0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }
                }
            }

            // Forecast row - horizontal layout
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: ScalerService.s(8)

                Repeater {
                    model: WeatherService.dataModel.forecast.forecastday

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: ScalerService.s(8)
                            spacing: ScalerService.s(4)

                            // Day name
                            CustomText {
                                name: getDayName(modelData.date)
                                isBold: true
                                size: "small"
                                Layout.alignment: Qt.AlignHCenter
                                elide: Text.ElideRight
                                opacity: 0
                                SequentialAnimation on opacity {
                                    running: root.animationProgress > 0.85

                                    PauseAnimation {
                                        duration: index * 50
                                    }

                                    NumberAnimation {
                                        to: 1
                                        duration: 200
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }

                            // Weather icon
                            IconImage {
                                path: WeatherService.getWeatherIcon(modelData.day.condition.code)
                                size: "normal"
                                Layout.alignment: Qt.AlignHCenter
                                opacity: 0
                                SequentialAnimation on opacity {
                                    running: root.animationProgress > 0.85

                                    PauseAnimation {
                                        duration: index * 30
                                    }

                                    NumberAnimation {
                                        to: 1
                                        duration: 200
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }

                            // Temperature range
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                spacing: ScalerService.s(2)

                                CustomText {
                                    name: `${modelData.day.mintemp_c}°`
                                    textColor: theme.normal.cyan

                                    size: "small"
                                    isBold: true
                                    opacity: 0
                                    SequentialAnimation on opacity {
                                        running: root.animationProgress > 0.85

                                        PauseAnimation {
                                            duration: index * 20
                                        }

                                        NumberAnimation {
                                            to: 1
                                            duration: 200
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                CustomText {
                                    name: "/"
                                    textColor: theme.primary.dim_foreground
                                    size: "small"
                                    isBold: true
                                    opacity: 0
                                    SequentialAnimation on opacity {
                                        running: root.animationProgress > 0.85

                                        PauseAnimation {
                                            duration: index * 40
                                        }

                                        NumberAnimation {
                                            to: 1
                                            duration: 200
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                CustomText {
                                    name: `${modelData.day.maxtemp_c}°`
                                    textColor: theme.normal.red

                                    size: "small"
                                    isBold: true
                                    opacity: 0
                                    SequentialAnimation on opacity {
                                        running: root.animationProgress > 0.85

                                        PauseAnimation {
                                            duration: index * 60
                                        }

                                        NumberAnimation {
                                            to: 1
                                            duration: 200
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                            }
                        }
                    }
                }
            }
        }
    }
}
