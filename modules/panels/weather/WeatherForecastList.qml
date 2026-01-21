import QtQuick
import QtQuick.Layouts

Rectangle {
    id: forecastSection

    required property var theme
    required property var forecastDays

    visible: forecastDays.length > 0
    Layout.fillWidth: true
    Layout.preferredHeight: 200
    radius: 16
    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Forecast row - horizontal layout
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            Repeater {
                model: forecastSection.forecastDays

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
                    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8

                        // Day name
                        Text {
                            text: modelData.dayName
                            color: theme.primary.foreground
                            font {
                                pixelSize: 24
                                bold: index === 0
                                family: "ComicShannsMono Nerd Font"
                            }
                            Layout.alignment: Qt.AlignHCenter
                            elide: Text.ElideRight
                        }

                        // Date
                        Text {
                            text: modelData.dateText
                            color: theme.primary.dim_foreground
                            font {
                                pixelSize: 20
                                family: "ComicShannsMono Nerd Font"
                            }
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Weather icon
                          Image {
                    source: modelData.icon
                            Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false
                    smooth: true
                    mipmap: true
                }

                        // Temperature range
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 4

                            Text {
                                text: `${modelData.minTemp}°`
                                color: theme.normal.cyan
                                font {
                                    pixelSize: 24
                                    bold: true
                                    family: "ComicShannsMono Nerd Font"
                                }
                            }

                            Text {
                                text: "/"
                                color: theme.primary.dim_foreground
                                font.pixelSize: 24
                            }

                            Text {
                                text: `${modelData.maxTemp}°`
                                color: theme.normal.red
                                font {
                                    pixelSize: 24
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
