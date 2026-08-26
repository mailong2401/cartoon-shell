import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.commons
import qs.components

Item {
    id: root

    property string title: "CPU"
    property real value: 23
    property color progressColor: theme.normal.red
    property color trackColor: theme.button.border
    property color textColor: theme.primary.foreground
    property real strokeWidth: 6

    implicitWidth: 160
    implicitHeight: 200

    property real animatedValue: value
    Behavior on animatedValue {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutCubic
        }
    }

    onAnimatedValueChanged: canvas.requestPaint()

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var centerX = width / 2;
                    var centerY = height / 2;
                    var radius = (Math.min(width, height) - root.strokeWidth) / 2 - 10;
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
                    ctx.lineWidth = root.strokeWidth;
                    ctx.strokeStyle = root.trackColor;
                    ctx.stroke();
                    var startAngle = -Math.PI / 2;
                    var sweepAngle = (root.animatedValue / 100) * (2 * Math.PI);
                    var endAngle = startAngle + sweepAngle;

                    if (root.animatedValue > 0) {
                        ctx.beginPath();
                        ctx.arc(centerX, centerY, radius, startAngle, endAngle, false);
                        ctx.lineWidth = root.strokeWidth;
                        ctx.strokeStyle = root.progressColor;
                        ctx.lineCap = "round";
                        ctx.stroke();
                    }
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                CustomText {
                    Layout.alignment: Qt.AlignHCenter
                    name: root.title
                    size: "medium"
                    color: root.progressColor
                    isBold: true
                }
                CustomText {
                    Layout.alignment: Qt.AlignHCenter
                    name: `${Math.round(root.animatedValue)}%`
                    size: "small"
                    color: theme.primary.dim_foreground
                    isBold: true
                }
            }
        }
    }
}
