import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell
import qs.commons
import qs.components
import qs.services

PanelWindow {
    id: root

    implicitWidth: ScalerService.s(480)
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Bottom
    property bool visibleCalendarWidget: root.allHidden("launcher", "music", "cpu", "ram", "dashboard", "weather", "keybind", "packagePanel")
    property bool visibleClockWidget: root.allHidden("launcher", "music", "cpu", "ram", "dashboard", "weather", "keybind", "packagePanel")
    property bool visibleMusicWidget: root.allHidden("cpu", "ram", "dashboard", "weather", "keybind", "packagePanel")
    function allHidden(...items) {
        return items.every(item => !VisibleService.getPanelVisible(item));
    }

    ColumnLayout {
        anchors.fill: parent
        Loader {
            source: "../widgets/calendar/CalendarWidget.qml"
            active: root.visibleCalendarWidget
            onLoaded: {
                item.visible = Qt.binding(function () {
                    root.visibleCalendarWidget;
                });
            }
        }
        Item {
            Layout.fillHeight: true
        }
        Loader {
            source: "../widgets/clock/ClockWidget.qml"
            active: root.visibleClockWidget
            onLoaded: {
                item.visible = Qt.binding(function () {
                    root.visibleClockWidget;
                });
            }
        }
        Item {
            Layout.fillHeight: true
        }
        Loader {
            source: "../widgets/player/PlayerWidget.qml"
            active: root.visibleMusicWidget
            onLoaded: {
                item.visible = Qt.binding(function () {
                    root.visibleMusicWidget;
                });
            }
        }
    }

    anchors {
        top: true
        left: true
        bottom: true
    }

    margins {
        top: ScalerService.s(20)
        bottom: ScalerService.s(20)
        left: ScalerService.s(20)
    }
    color: "transparent"
}
