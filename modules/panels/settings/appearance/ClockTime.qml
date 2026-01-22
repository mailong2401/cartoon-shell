import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "clockTime" as Com

Item{
  id: root
  property var theme: currentTheme
  property var lang: currentLanguage
  property var panelConfig
      ColumnLayout {
          width: parent.width
          spacing: 20

          Text {
              text: lang.appearance?.clock || "Clock"
              color: theme.primary.foreground
              font {
                  family: "ComicShannsMono Nerd Font"
                  pixelSize: 24
                  bold: true
              }
          }

          Rectangle {
            width: parent.width
              height: 1
              color: theme.primary.foreground
              opacity: 0.3
          }

          // Nội dung Clock ở đây
          Text {
              text: "Clock settings content"
              color: theme.primary.foreground
            }
            Com.ClockPanelToggle{
              Layout.fillWidth: true
              panelConfig: root.panelConfig
            }
            Com.ClockPositionSelector{
              Layout.fillWidth: true
              panelConfig: root.panelConfig
            }
      }
}
