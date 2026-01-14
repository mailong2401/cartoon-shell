import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property int emailCount: 230
    property var theme: currentTheme

    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 28
    color: "#eff1f5"
    border.width: 3
    border.color: theme.normal.black

    RowLayout {
        anchors.centerIn: parent
        spacing: 20

        Image {
            source: "../../../assets/lockscreen/appicons/gmail.png"
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Label {
            text: root.emailCount.toString()
            color: "#333333"
            font.family: "ComicShannsMono Nerd Font"
            font.pixelSize: 36
            font.bold: true
        }
    }
}
