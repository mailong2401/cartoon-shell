import QtQuick
import QtQuick.Layouts

Rectangle {
    property var theme: currentTheme
    property var cpuHistory: []

    color: "transparent"
    border.color: theme.button.border
    border.width: 2
    radius: 6

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // Main chart area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            // Title row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                spacing: 8
                Item {
                  Layout.fillWidth: true
                }
                Text {
        text: "CPU Usage History"
        color: theme.primary.foreground
        font.pixelSize: 32
        font.bold: true
        font.family: "ComicShannsMono Nerd Font"
    }Item {
        Layout.fillWidth: true
    }
            }

            // Chart area
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Canvas {
                    id: cpuChart
                    anchors.fill: parent
                    antialiasing: true

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        
                        if (cpuHistory.length < 2) return;

                        var width = cpuChart.width;
                        var height = cpuChart.height;
                        var paddingLeft = 60;
                        var paddingRight = 20; // Extra space for percentage labels
                        var paddingTop = 30;
                        var paddingBottom = 20;
                        var chartWidth = width - paddingLeft - paddingRight;
                        var chartHeight = height - paddingTop - paddingBottom;

                        // Draw background
                        ctx.fillStyle = theme.primary.dim_background;
                        ctx.fillRect(paddingLeft, paddingTop, chartWidth, chartHeight);

                        ctx.globalAlpha = 1.0;

                        // Draw horizontal grid lines and percentage labels
                        ctx.strokeStyle = theme.button.border;
                        ctx.lineWidth = 1;
                        ctx.globalAlpha = 1;
                        ctx.font = "17px 'ComicShannsMono Nerd Font'";
                        ctx.fillStyle = theme.primary.foreground;
                        ctx.textAlign = "right";
                        ctx.textBaseline = "middle";

                        for (var i = 0; i <= 10; i++) {
                            var percentage = i * 10;
                            var y = paddingTop + chartHeight - (chartHeight * percentage / 100);
                            
                            // Draw grid line
                            ctx.beginPath();
                            ctx.moveTo(paddingLeft, y);
                            ctx.lineTo(paddingLeft + chartWidth, y);
                            ctx.stroke();

                            // Draw percentage label
                            ctx.fillText(percentage + "%", paddingLeft - 5, y);
                        }

                        ctx.globalAlpha = 1.0;

                        // Draw CPU usage line with smooth curve
                        if (cpuHistory.length > 0) {
                            var gradient = ctx.createLinearGradient(paddingLeft, paddingTop, paddingLeft, height - paddingBottom);
                            gradient.addColorStop(0, theme.normal.blue);
                            gradient.addColorStop(1, theme.normal.blue);
                            
                            // Calculate all points first
                            var points = [];
                            for (var j = 0; j < cpuHistory.length; j++) {
                                var x = paddingLeft + (chartWidth * j / (cpuHistory.length - 1));
                                var usage = cpuHistory[j].usage;
                                var y = paddingTop + chartHeight - (chartHeight * usage / 100);
                                points.push({x: x, y: y});
                            }
                            
                            // Fill area under smooth curve
                            ctx.fillStyle = gradient;
                            ctx.beginPath();
                            
                            // Start from bottom left
                            ctx.moveTo(paddingLeft, paddingTop + chartHeight);
                            
                            // Draw smooth curve to first point
                            ctx.lineTo(points[0].x, paddingTop + chartHeight);
                            ctx.lineTo(points[0].x, points[0].y);
                            
                            // Draw smooth curve through all points
                            for (var j = 0; j < points.length - 1; j++) {
                                var xc = (points[j].x + points[j + 1].x) / 2;
                                var yc = (points[j].y + points[j + 1].y) / 2;
                                
                                if (j === 0) {
                                    ctx.quadraticCurveTo(points[j].x, points[j].y, xc, yc);
                                } else {
                                    var prevXc = (points[j-1].x + points[j].x) / 2;
                                    var prevYc = (points[j-1].y + points[j].y) / 2;
                                    ctx.bezierCurveTo(prevXc, prevYc, points[j].x, points[j].y, xc, yc);
                                }
                            }
                            
                            // Draw last segment
                            if (points.length > 1) {
                                var lastIndex = points.length - 1;
                                var prevXc = (points[lastIndex-1].x + points[lastIndex].x) / 2;
                                var prevYc = (points[lastIndex-1].y + points[lastIndex].y) / 2;
                                ctx.bezierCurveTo(prevXc, prevYc, points[lastIndex].x, points[lastIndex].y, 
                                                points[lastIndex].x, points[lastIndex].y);
                            }
                            
                            // Close the path to fill area
                            ctx.lineTo(points[points.length-1].x, paddingTop + chartHeight);
                            ctx.lineTo(paddingLeft, paddingTop + chartHeight);
                            ctx.closePath();
                            ctx.fill();

                            // Draw smooth curve line
                            ctx.strokeStyle = theme.normal.blue;
                            ctx.lineWidth = 3;
                            ctx.lineJoin = "round";
                            ctx.lineCap = "round";
                            ctx.beginPath();
                            
                            // Move to first point
                            ctx.moveTo(points[0].x, points[0].y);
                            
                            // Draw smooth curve through all points
                            for (var j = 0; j < points.length - 1; j++) {
                                var xc = (points[j].x + points[j + 1].x) / 2;
                                var yc = (points[j].y + points[j + 1].y) / 2;
                                
                                if (j === 0) {
                                    ctx.quadraticCurveTo(points[j].x, points[j].y, xc, yc);
                                } else {
                                    var prevXc = (points[j-1].x + points[j].x) / 2;
                                    var prevYc = (points[j-1].y + points[j].y) / 2;
                                    ctx.bezierCurveTo(prevXc, prevYc, points[j].x, points[j].y, xc, yc);
                                }
                            }
                            
                            // Draw last segment
                            if (points.length > 1) {
                                var lastIndex = points.length - 1;
                                var prevXc = (points[lastIndex-1].x + points[lastIndex].x) / 2;
                                var prevYc = (points[lastIndex-1].y + points[lastIndex].y) / 2;
                                ctx.bezierCurveTo(prevXc, prevYc, points[lastIndex].x, points[lastIndex].y, 
                                                points[lastIndex].x, points[lastIndex].y);
                            }
                            
                            ctx.stroke();

                            // Draw current usage value
                            if (cpuHistory.length > 0) {
                                var currentUsage = cpuHistory[cpuHistory.length - 1].usage;
                                var currentX = paddingLeft + chartWidth;
                                var currentY = points[points.length - 1].y;
                                
                                ctx.font = "15px 'ComicShannsMono Nerd Font'";
                                ctx.fillText(currentUsage.toFixed(1) + "%", currentX + 5, currentY - 8);
                            }
                        }

                        // Draw chart border
                        ctx.strokeStyle = theme.normal.black;
                        ctx.lineWidth = 2;
                        ctx.globalAlpha = 0.5;
                        ctx.strokeRect(paddingLeft, paddingTop, chartWidth, chartHeight);
                        ctx.globalAlpha = 1.0;
                    }
                }
            }

            // Legend
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                spacing: 20
                
                Layout.alignment: Qt.AlignHCenter

                RowLayout {
                    spacing: 6

                    Rectangle {
                        Layout.preferredHeight: 12
                        Layout.preferredWidth: 12
                        color: theme.normal.green
                        radius: 2
                    }
                    Text {
                        text: "Low (<50%)"
                        color: theme.primary.dim_foreground
                        font.pixelSize: 12
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }

                RowLayout {
                    spacing: 6

                    Rectangle {
                        Layout.preferredHeight: 12
                        Layout.preferredWidth: 12
                        color: theme.normal.yellow
                        radius: 2
                    }
                    Text {
                        text: "Medium (50-80%)"
                        color: theme.primary.dim_foreground
                        font.pixelSize: 12
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }

                RowLayout {
                    spacing: 6

                    Rectangle {
                        Layout.preferredHeight: 12
                        Layout.preferredWidth: 12
                        color: theme.normal.red
                        radius: 2
                    }
                    Text {
                        text: "High (>80%)"
                        color: theme.primary.dim_foreground
                        font.pixelSize: 12
                        font.family: "ComicShannsMono Nerd Font"
                    }
                }
            }
        }

    }

    onCpuHistoryChanged: {
        cpuChart.requestPaint();
    }
}
