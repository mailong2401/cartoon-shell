import QtQuick


Item {
    property var listCategories: [
      {
            categoryName: "General",
            items: [
                { name: "Language & Region", icon: "../../../assets/settings/language.png", category: "language" },
                { name: "Date & Time", icon: "../../../assets/settings/calendar-clock.png", category: "datetime" },
                { name: "Session", icon: "../../../assets/settings/session.png", category: "session" },
                { name: "Behavior", icon: "../../../assets/settings/behavior.png", category: "behavior" },
                { name: "Notifications", icon: "../../../assets/settings/bell.png", category: "notifications" },
                { name: "Privacy", icon: "../../../assets/settings/shield.png", category: "privacy" },
                { name: "Accessibility", icon: "../../../assets/settings/accessibility.png", category: "accessibility" },
                { name: "Advanced", icon: "../../../assets/settings/advanced.png", category: "advanced" }
            ]
        },
        {
            categoryName: "Appearance",
            items: [
                { name: "Theme", icon: "../../../assets/settings/paint-brush.png", category: "theme" },
                { name: "Panel", icon: "../../../assets/settings/layout.png", category: "panel" },
                { name: "Clock", icon: "../../../assets/settings/clock.png", category: "clock" },
                { name: "Fonts", icon: "../../../assets/settings/font.png", category: "fonts" },
                { name: "Icons", icon: "../../../assets/settings/icon.png", category: "icons" },
                { name: "Effects", icon: "../../../assets/settings/sparkles.png", category: "effects" },
                { name: "Layout", icon: "../../../assets/settings/grid.png", category: "layout" },
                { name: "Wallpaper", icon: "../../../assets/settings/Wallpaper.png", category: "wallpaper" }
            ]
        }
        
    ]
    
    // ListCategories[1].items[3].name // "Behavior"
}
