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

        AppIcon { iconSource: "../../../assets/lockscreen/appicons/youtube.png"; bgColor: "#ff6b6b" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/facebook.png"; bgColor: "#5fd3d3" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/tiktok.png"; bgColor: "#a8b2d1" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/reddit.png"; bgColor: "#eeeeee" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/youtube.png"; bgColor: "#5fd3d3" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/facebook.png"; bgColor: "#ffb86c" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/tiktok.png"; bgColor: "#4da6ff" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/reddit.png"; bgColor: "#eeeeee" }
        AppIcon { iconSource: "../../../assets/lockscreen/appicons/youtube.png"; bgColor: "#5fd3d3" }
    }
}
