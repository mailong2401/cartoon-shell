import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.components

RowLayout{
  visible: !panelManager.fullsetting
  property var name: ""
  property var theme: currentTheme

      Layout.fillWidth: true
  Text {
  text: name
  color: theme.primary.foreground
  font {
    family: "ComicShannsMono Nerd Font"
    pixelSize: 24
    bold: true
  }
  Layout.alignment: Qt.AlignLeft
}
Item{
  Layout.fillWidth: true
}
  ButtonAdvanced{}
}
