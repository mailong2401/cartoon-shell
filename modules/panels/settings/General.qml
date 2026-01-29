// components/Settings/GeneralSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components
import "./general/" as Com

Item {
    property var theme: currentTheme
    property var lang: currentLanguage
    id: root
    
    property int currentTab: 0
    
    // Timer để reload ngôn ngữ
    property Timer reloadTimer: Timer {
        interval: 30
        repeat: false
        onTriggered: languageLoader.loadLanguage()
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        // Nội dung các tab
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentTab
            
            // Tab 0: Language & Region
            Com.LanguageRegion{
            }
            
            // Tab 1: Date & Time
            ScrollView {
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    anchors.margins: 20
                    
                    Text {
                        text: lang.general?.date_time || "Date & Time"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }
                    
                    // Nội dung Date & Time ở đây
                    Text {
                        text: "Date & Time settings content"
                        color: theme.primary.foreground
                        Layout.alignment: Qt.AlignLeft
                    }
                }
            }
            
            // Tab 2: Session
            ScrollView {
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    anchors.margins: 20
                    
                    Text {
                        text: lang.general?.session || "Session"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }
                    
                    // Nội dung Session ở đây
                    Text {
                        text: "Session settings content"
                        color: theme.primary.foreground
                        Layout.alignment: Qt.AlignLeft
                    }
                }
            }
            
            // Tab 3: Behavior
            ScrollView {
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    anchors.margins: 20
                    
                    Text {
                        text: lang.general?.behavior || "Behavior"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }
                    
                    // Nội dung Behavior ở đây
                    Text {
                        text: "Behavior settings content"
                        color: theme.primary.foreground
                        Layout.alignment: Qt.AlignLeft
                    }
                }
            }
            
            // Tab 4: Notifications
            ScrollView {
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    anchors.margins: 20
                    
                    Text {
                        text: lang.general?.notifications || "Notifications"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }
                    
                    // Nội dung Notifications ở đây
                    Text {
                        text: "Notifications settings content"
                        color: theme.primary.foreground
                        Layout.alignment: Qt.AlignLeft
                    }
                }
            }
            
            // Tab 5: Privacy
            ScrollView {
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    anchors.margins: 20
                    
                    Text {
                        text: lang.general?.privacy || "Privacy"
                        color: theme.primary.foreground
                        font {
                            family: "ComicShannsMono Nerd Font"
                            pixelSize: 24
                            bold: true
                        }
                        Layout.alignment: Qt.AlignLeft
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.primary.foreground
                        opacity: 0.3
                    }
                    
                    // Nội dung Privacy ở đây
                    Text {
                        text: "Privacy settings content"
                        color: theme.primary.foreground
                        Layout.alignment: Qt.AlignLeft
                    }
                }
            }
            

        }
    }
    
    Component.onCompleted: {
        console.log("GeneralSettings loaded")
    }
}
