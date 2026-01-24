import QtQuick


Item {
    property var listCategories: [
      {
            categoryName: "General",
            items: [
                { name: "Language & Region", icon: "../../../assets/settings/languages.png", category: "language" },
                { name: "Date & Time", icon: "../../../assets/settings/time.png", category: "datetime" },
                { name: "Startup", icon: "../../../assets/settings/startup.png", category: "session" },
                { name: "Behavior", icon: "../../../assets/settings/behavior.png", category: "behavior" },
                { name: "Notifications", icon: "../../../assets/settings/notification.png", category: "notifications" },
                { name: "Privacy", icon: "../../../assets/settings/privacy.png", category: "privacy" },
            ]
        },
        {
            categoryName: "Appearance",
            items: [
                { name: "Theme", icon: "../../../assets/settings/theme.png", category: "theme" },
                { name: "Panel", icon: "../../../assets/settings/layout.png", category: "panel" },
                { name: "Clock", icon: "../../../assets/settings/clock.png", category: "clock" },
                { name: "Fonts", icon: "../../../assets/settings/fonts.png", category: "fonts" },
                { name: "Icons", icon: "../../../assets/settings/icons.png", category: "icons" },
                { name: "Effects", icon: "../../../assets/settings/effects.png", category: "effects" },
                { name: "Layout", icon: "../../../assets/settings/layout.png", category: "layout" },
                { name: "Wallpaper", icon: "../../../assets/settings/Wallpaper.png", category: "wallpaper" }
            ]
        }
        
    ]
    
    // ListCategories[1].items[3].name // "Behavior"
}
