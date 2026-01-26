import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.services

Rectangle {
    id: root
    radius: 10
    border.color: theme.button.border
    border.width: 3

    property var theme: currentTheme
    color: theme.primary.background

    // Hyprland service facade
    property ListModel workspaces: ListModel {}
    property var windows: []
    property int focusedWindowIndex: -1
    property string activeWorkspace: "1"
    property bool initialized: false
    
    // Workspace UI data - lưu 10 workspace đầu (1-10)
    property var uiWorkspaces: []
    
    // Debounce timer for updates
    Timer {
        id: updateTimer
        interval: 50
        repeat: false
        onTriggered: updateUIWorkspaces()
    }

    // Khởi tạo Hyprland service
    function initialize() {
        if (initialized) return;
        
        try {
            Hyprland.refreshWorkspaces();
            Hyprland.refreshToplevels();
            Qt.callLater(() => {
                safeUpdateWorkspaces();
                safeUpdateWindows();
                initUIWorkspaces();
            });
            initialized = true;
        } catch (e) {
            console.log("Failed to initialize Hyprland service:", e);
        }
    }

    // Khởi tạo UI workspaces với 10 workspace đầu
    function initUIWorkspaces() {
        var uiWorkspacesArray = [];
        for (var i = 1; i <= 10; i++) {
            uiWorkspacesArray.push({
                "id": i.toString(),
                "exists": false,
                "isActive": false
            });
        }
        root.uiWorkspaces = uiWorkspacesArray;
        updateUIWorkspaces();
    }

    // Cập nhật UI workspaces từ dữ liệu Hyprland
    function updateUIWorkspaces() {
        if (!initialized || workspaces.count === 0) return;

        // Tạo map để tra cứu nhanh workspace
        var workspaceMap = {};
        for (var i = 0; i < workspaces.count; i++) {
            var ws = workspaces.get(i);
            workspaceMap[ws.id.toString()] = ws;
        }

        // Cập nhật UI workspaces
        for (var j = 0; j < uiWorkspaces.length; j++) {
            var uiWs = uiWorkspaces[j];
            var wsId = uiWs.id;
            var wsData = workspaceMap[wsId];
            
            if (wsData) {
                uiWs.exists = wsData.isOccupied || false;
                uiWs.isActive = (wsData.id.toString() === activeWorkspace);
            } else {
                uiWs.exists = false;
                uiWs.isActive = false;
            }
        }
        
        // Force UI update
        root.uiWorkspaces = uiWorkspaces.slice();
    }

    // Chuyển workspace
    function switchWs(id) {
        try {
            Hyprland.dispatch(`workspace ${id}`);
            activeWorkspace = id;
            markWorkspaceExists(id);
        } catch (e) {
            console.log("Failed to switch workspace:", e);
        }
    }

    // Đánh dấu workspace có tồn tại
    function markWorkspaceExists(id, state = true) {
        for (var i = 0; i < uiWorkspaces.length; i++) {
            if (uiWorkspaces[i].id === id) {
                uiWorkspaces[i].exists = state;
                break;
            }
        }
        root.uiWorkspaces = uiWorkspaces.slice();
    }

    // Safe workspace update
    function safeUpdateWorkspaces() {
        try {
            workspaces.clear();
            
            if (!Hyprland.workspaces || !Hyprland.workspaces.values) {
                return;
            }

            const hlWorkspaces = Hyprland.workspaces.values;
            const occupiedIds = getOccupiedWorkspaceIds();

            for (var i = 0; i < hlWorkspaces.length; i++) {
                const ws = hlWorkspaces[i];
                if (!ws || ws.id < 1) continue;
                
                const wsData = {
                    "id": ws.id,
                    "idx": ws.id,
                    "name": ws.name || "",
                    "output": (ws.monitor && ws.monitor.name) ? ws.monitor.name : "",
                    "isActive": ws.active === true,
                    "isFocused": ws.focused === true,
                    "isUrgent": ws.urgent === true,
                    "isOccupied": occupiedIds[ws.id] === true
                };

                workspaces.append(wsData);

                if (wsData.isFocused) {
                    root.activeWorkspace = wsData.id.toString();
                }
            }
            
            updateTimer.restart();
        } catch (e) {
            console.log("Error updating workspaces:", e);
        }
    }

    // Get occupied workspace IDs safely
    function getOccupiedWorkspaceIds() {
        const occupiedIds = {};

        try {
            if (!Hyprland.toplevels || !Hyprland.toplevels.values) {
                return occupiedIds;
            }

            const hlToplevels = Hyprland.toplevels.values;
            for (var i = 0; i < hlToplevels.length; i++) {
                const toplevel = hlToplevels[i];
                if (!toplevel) continue;
                
                try {
                    const wsId = toplevel.workspace ? toplevel.workspace.id : null;
                    if (wsId !== null && wsId !== undefined) {
                        occupiedIds[wsId] = true;
                    }
                } catch (e) {
                    // Ignore individual toplevel errors
                }
            }
        } catch (e) {
            // Return empty if we can't determine occupancy
        }

        return occupiedIds;
    }

    // Safe window update
    function safeUpdateWindows() {
        try {
            const windowsList = [];

            if (!Hyprland.toplevels || !Hyprland.toplevels.values) {
                windows = [];
                focusedWindowIndex = -1;
                return;
            }

            const hlToplevels = Hyprland.toplevels.values;
            let newFocusedIndex = -1;

            for (var i = 0; i < hlToplevels.length; i++) {
                const toplevel = hlToplevels[i];
                if (!toplevel) continue;
                
                const windowData = extractWindowData(toplevel);
                if (windowData) {
                    windowsList.push(windowData);

                    if (windowData.isFocused) {
                        newFocusedIndex = windowsList.length - 1;
                    }
                }
            }

            windows = windowsList;

            if (newFocusedIndex !== focusedWindowIndex) {
                focusedWindowIndex = newFocusedIndex;
            }
        } catch (e) {
            console.log("Error updating windows:", e);
        }
    }

    // Extract window data safely from a toplevel
    function extractWindowData(toplevel) {
        if (!toplevel) return null;

        try {
            const windowId = safeGetProperty(toplevel, "address", "");
            if (!windowId) return null;

            const appId = getAppId(toplevel);
            const title = getAppTitle(toplevel);
            const wsId = toplevel.workspace ? toplevel.workspace.id : null;
            const focused = toplevel.activated === true;
            const output = toplevel.monitor?.name || "";

            return {
                "id": windowId,
                "title": title,
                "appId": appId,
                "workspaceId": wsId || -1,
                "isFocused": focused,
                "output": output
            };
        } catch (e) {
            return null;
        }
    }

    function getAppTitle(toplevel) {
        try {
            var title = toplevel.wayland.title;
            if (title) return title;
        } catch (e) {}

        return safeGetProperty(toplevel, "title", "");
    }

    function getAppId(toplevel) {
        if (!toplevel) return "";

        var appId = "";

        try {
            appId = toplevel.wayland.appId;
            if (appId) return appId;
        } catch (e) {}

        appId = safeGetProperty(toplevel, "class", "");
        if (appId) return appId;

        appId = safeGetProperty(toplevel, "initialClass", "");
        if (appId) return appId;

        appId = safeGetProperty(toplevel, "appId", "");
        if (appId) return appId;

        try {
            const ipcData = toplevel.lastIpcObject;
            if (ipcData) {
                return String(ipcData.class || ipcData.initialClass || ipcData.appId || ipcData.wm_class || "");
            }
        } catch (e) {}

        return "";
    }

    // Safe property getter
    function safeGetProperty(obj, prop, defaultValue) {
        try {
            const value = obj[prop];
            if (value !== undefined && value !== null) {
                return String(value);
            }
        } catch (e) {
            // Property access failed
        }
        return defaultValue;
    }

    // Connections to Hyprland
    Connections {
        target: Hyprland.workspaces
        enabled: root.initialized
        function onValuesChanged() {
            root.safeUpdateWorkspaces();
        }
    }

    Connections {
        target: Hyprland.toplevels
        enabled: root.initialized
        function onValuesChanged() {
            root.safeUpdateWindows();
            root.safeUpdateWorkspaces();
            updateTimer.restart();
        }
    }

    Connections {
        target: Hyprland
        enabled: root.initialized
        function onRawEvent(event) {
            Hyprland.refreshWorkspaces();
            root.safeUpdateWorkspaces();
            
            const workspaceEvents = ["workspace", "createworkspace", "destroyworkspace", "focusedmon"];
            if (workspaceEvents.includes(event.name)) {
                updateTimer.restart();
            }
        }
    }

    // UI Layout
    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: root.uiWorkspaces
            Rectangle {
                property string wsId: modelData.id
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 6
                color: "transparent"

                Image {
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    fillMode: Image.PreserveAspectFit
                    source: modelData.isActive
                        ? "../../assets/workspace/pacman.png"
                        : modelData.exists
                            ? "../../assets/workspace/ghost.png"
                            : "../../assets/workspace/empty.png"
                    opacity: 1
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.switchWs(modelData.id)
                    onEntered: if (wsId !== root.activeWorkspace) parent.scale = 1.1
                    onExited: if (wsId !== root.activeWorkspace) parent.scale = 1.0
                }

                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }

    Component.onCompleted: {
        initialize();
    }
}
