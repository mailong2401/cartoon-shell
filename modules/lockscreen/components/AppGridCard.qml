import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root

    property var theme: currentTheme

    Layout.preferredWidth: 220
    Layout.preferredHeight: 220
    radius: 28
    color: theme.primary.background

    GridLayout {
        anchors.fill: parent
        anchors.margins: 20
        columns: 3
        rows: 3
        columnSpacing: 15
        rowSpacing: 15

        AppIcon { icon: ""; iconColor: "#ff6b6b" }
        AppIcon { icon: ""; iconColor: "#5fd3d3" }
        AppIcon { icon: ""; iconColor: "#a8b2d1" }
        AppIcon { icon: ""; iconColor: "#eeeeee" }
        AppIcon { icon: ""; iconColor: "#5fd3d3" }
        AppIcon { icon: ""; iconColor: "#ffb86c" }
        AppIcon { icon: ""; iconColor: "#4da6ff" }
        AppIcon { icon: ""; iconColor: "#eeeeee" }
        AppIcon { icon: ""; iconColor: "#5fd3d3" }
    }
}
