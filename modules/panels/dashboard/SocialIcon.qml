import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    property string image: ""
    property string linkSocial: ""
    property color bgColor: "white"
    property real hoverScale: 1.2 // Tỷ lệ phóng to khi hover
    property var theme: currentTheme

    Layout.fillHeight: true
    Layout.preferredWidth: height
    radius: 22
    color: bgColor
    border.width: 3
    border.color: theme.button.border
    
    Process { id: linkProcess }

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
        width: 30
        height: 30
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
                iconImage.scale = 1.1
            }
        }
        
        onClicked: {
          linkProcess.command = ["xdg-open", linkSocial]
          linkProcess.startDetached()
          console.log("ksdjf")
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
                border.color: theme.button.border
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
            }
            PropertyChanges { 
                target: iconImage
                scale: hoverScale
            }
        }
    ]
    
    // Khởi tạo với trạng thái normal
    state: "normal"
    
    // Hiệu ứng đổ bóng khi hover (tùy chọn)
}
