import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
 property var theme: currentTheme
 property var lang: currentLanguage
    id: advancedButton
    visible: !panelManager.fullsetting
    text: "Nâng cao"
    font.family: "ComicShannsMono Nerd Font"
    font.pixelSize: 14
    
    background: Rectangle {
        color: advancedButton.hovered ? theme.button.hover : theme.button.background
        border.color: theme.button.border
        border.width: 1
        radius: 8
    }
    
    contentItem: Text {
        text: advancedButton.text
        font: advancedButton.font
        color: theme.primary.foreground
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    onClicked: {
        panelManager.togglePanel("fullsetting")
        // Thêm xử lý khi click vào đây
    }
  }
