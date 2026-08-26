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
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    property bool visibleGameWidget: root.allHidden("cpu", "ram", "dashboard", "weather", "keybind", "packagePanel", "wifi", "bluetooth", "mixer")
    property bool visibleSystemWidget: root.allHidden("cpu", "ram", "dashboard", "weather", "keybind", "packagePanel", "wifi")
    function allHidden(...items) {
        return items.every(item => !VisibleService.getPanelVisible(item));
    }

    ColumnLayout {
        anchors.fill: parent
        Loader {
            source: "../widgets/games/MenuGameWidget.qml"
            active: root.visibleGameWidget
            onLoaded: {
                item.visible = Qt.binding(function () {
                    root.visibleGameWidget;
                });
            }
        }
        Loader {
            source: "../widgets/system/SystemWidget.qml"
            active: root.visibleSystemWidget
            onLoaded: {
                item.visible = Qt.binding(function () {
                    root.visibleSystemWidget;
                });
            }
        }
    }

    anchors {
        top: true
        right: true
        bottom: true
    }

    margins {
        top: ScalerService.s(20)
        bottom: ScalerService.s(20)
        right: ScalerService.s(20)
    }
    color: "transparent"
}
