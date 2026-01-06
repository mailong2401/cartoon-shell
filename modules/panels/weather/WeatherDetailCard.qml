import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var theme: currentTheme
    property string image: ""
    property string value: "Value"

    radius: 12
    color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.05)
    border.color: Qt.rgba(theme.normal.black.r, theme.normal.black.g, theme.normal.black.b, 0.1)
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        // Thay Text bằng Image
        Image {
            source: root.image
            sourceSize.width: 32
            sourceSize.height: 32
            fillMode: Image.PreserveAspectFit
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: root.value
            color: theme.primary.foreground
            font {
                pixelSize: 16
                bold: true
                family: "ComicShannsMono Nerd Font"
            }
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
