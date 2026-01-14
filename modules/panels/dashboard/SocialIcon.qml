import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion

Rectangle {
    id: root
    property string image: ""
    property color bgColor: "white"
    property real hoverScale: 1.1 // Tỷ lệ phóng to khi hover
    property var theme: currentTheme
    property var sizes: currentSizes

    Layout.fillHeight: true
    Layout.preferredWidth: height
    radius: 22
    color: bgColor
    border.width: 3
    border.color: theme.normal.black
    
    // Hiệu ứng chuyển đổi mượt mà
    Behavior on scale {
        NumberAnimation { 
            duration: 150 
            easing.type: Easing.OutCubic
        }
    }
    
    Behavior on color {
        ColorAnimation { 
            duration: 150 
            easing.type: Easing.OutCubic
        }
    }
    
    Behavior on border.color {
        ColorAnimation { 
            duration: 150 
            easing.type: Easing.OutCubic
        }
    }

    Image {
        id: iconImage
        source: image
        anchors.centerIn: parent
        width: sizes.iconSize?.xlarge || 30
        height: sizes.iconSize?.xlarge || 30
        fillMode: Image.PreserveAspectFit
        smooth: true
        
        // Hiệu ứng phóng to icon khi hover
        Behavior on scale {
            NumberAnimation { 
                duration: 150 
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        // Theo dõi trạng thái hover
        onEntered: {
            root.state = "hovered"
        }
        
        onExited: {
            root.state = "normal"
        }
        
        // Hiệu ứng khi click
        onPressed: {
            root.scale = 0.95
            iconImage.scale = 0.95
        }
        
        onReleased: {
            if (containsMouse) {
                root.scale = hoverScale
                iconImage.scale = 1.1
            }
        }
        
        onClicked: {
            // Bạn có thể thêm hành động khi click ở đây
        }
    }
    
    // Trạng thái của component
    states: [
        State {
            name: "normal"
            PropertyChanges { 
                target: root
                color: bgColor
                scale: 1.0
                border.color: theme.normal.black
            }
            PropertyChanges { 
                target: iconImage
                scale: 1.0
            }
        },
        State {
            name: "hovered"
            PropertyChanges { 
                target: root
                scale: hoverScale
                border.color: theme.normal.darkGray // Border đậm hơn khi hover
            }
            PropertyChanges { 
                target: iconImage
                scale: 1.1 // Icon phóng to hơn một chút
            }
        }
    ]
    
    // Khởi tạo với trạng thái normal
    state: "normal"
    
    // Hiệu ứng đổ bóng khi hover (tùy chọn)
}
