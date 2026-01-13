import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

RowLayout {
    id: root
    property string iconDark: ""
    property string iconLight: ""
    property string label: ""
    property color iconColor: "white"
    property var theme: currentTheme
    property var sizes: currentSizes

    Layout.fillWidth: true
    spacing: 10

    Image {
      source: theme.type === "dark" ? iconDark : iconLight
      Layout.preferredWidth: sizes.iconSize?.large || 30
      Layout.preferredHeight: sizes.iconSize?.large || 30
      fillMode: Image.PreserveAspectFit
      smooth: true
    }

    Label {
        text: root.label
        color: iconColor
        font.family: "ComicShannsMono Nerd Font"
        font.pixelSize: sizes.fontSize?.title
    }
}
