import qs
import qs.services
import qs.modules.common
import qs.modules.common.models
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

ColumnLayout {
    id: root
    property bool vertical: false
    property bool borderless: Config.options.bar.borderless
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    
    readonly property int workspacesShown: Config.options.bar.workspaces.shown
    readonly property int workspaceGroup: Math.floor((monitor?.activeWorkspace?.id - 1) / root.workspacesShown)
    property list<bool> workspaceOccupied: []
    property int widgetPadding: 4
    property int workspaceButtonWidth: 26
    property real activeWorkspaceMargin: 2
    property real workspaceIconSize: workspaceButtonWidth * 0.69
    property real workspaceIconSizeShrinked: workspaceButtonWidth * 0.55
    property real workspaceIconOpacityShrinked: 1
    property real workspaceIconMarginShrinked: -4
    property int workspaceIndexInGroup: (monitor?.activeWorkspace?.id - 1) % root.workspacesShown

    property bool showNumbers: false
    Timer {
        id: showNumbersTimer
        interval: (Config?.options.bar.autoHide.showWhenPressingSuper.delay ?? 100)
        repeat: false
        onTriggered: {
            root.showNumbers = true
        }
    }
    Connections {
        target: GlobalStates
        function onSuperDownChanged() {
            if (!Config?.options.bar.autoHide.showWhenPressingSuper.enable) return;
            if (GlobalStates.superDown) showNumbersTimer.restart();
            else {
                showNumbersTimer.stop();
                root.showNumbers = false;
            }
        }
        function onSuperReleaseMightTriggerChanged() { 
            showNumbersTimer.stop()
        }
    }

    // Function to update workspaceOccupied
    function updateWorkspaceOccupied() {
        workspaceOccupied = Array.from({ length: root.workspacesShown }, (_, i) => {
            return Hyprland.workspaces.values.some(ws => ws.id === workspaceGroup * root.workspacesShown + i + 1);
        })
    }

    // Occupied workspace updates
    Component.onCompleted: updateWorkspaceOccupied()
    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            updateWorkspaceOccupied();
        }
    }
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            updateWorkspaceOccupied();
        }
    }
    onWorkspaceGroupChanged: {
        updateWorkspaceOccupied();
    }

    property var monitorWindows

    Connections {
        target: HyprlandData
        function onWindowListChanged() {
            const windowsOnMonitor = HyprlandData.windowList.filter(win => win.monitor === root.monitor.id && !win.floating)

            root.monitorWindows = windowsOnMonitor.map(win => ({
                icon: Quickshell.iconPath(AppSearch.guessIcon(win?.class), "image-missing"),
                workspace: win.workspace?.id
            }))

            //console.log("monitorWindows:", root.monitorWindows)
        }
    }

    // Scroll to switch workspaces
    WheelHandler {
        onWheel: (event) => {
            if (event.angleDelta.y < 0)
                Hyprland.dispatch(`workspace r+1`);
            else if (event.angleDelta.y > 0)
                Hyprland.dispatch(`workspace r-1`);
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton
        onPressed: (event) => {
            if (event.button === Qt.BackButton) {
                Hyprland.dispatch(`togglespecialworkspace`);
            } 
        }
    }

    property int individualIconBoxHeight: 24
    property int iconBoxWrapperSize: 28
    property var workspaceBackgroundMap: []

    onWorkspaceBackgroundMapChanged: {
        console.log(root.workspaceBackgroundMap)
    }


    implicitWidth: root.vertical ? Appearance.sizes.verticalBarWidth : (root.workspaceButtonWidth * root.workspacesShown)


    Rectangle { // active indicator
        id: activeIndicator
        Layout.alignment: Qt.AlignHCenter
        z: 10
        radius: 99
        color: Appearance.colors.colPrimary
        
        y: Math.min(idxPair.idx1, idxPair.idx2) * workspaceButtonWidth + root.activeWorkspaceMargin
        height: 20
        width: root.iconBoxWrapperSize

        AnimatedTabIndexPair {
            id: indPair
            index: root.workspaceIndexInGroup
        }
    }

    ColumnLayout {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 0

        Repeater {
            id: workspaceRepeater
            model: root.workspacesShown

            delegate: Rectangle { // background
                id: background
                z: 10
                Layout.alignment: Qt.AlignCenter
                implicitWidth: root.iconBoxWrapperSize 
                implicitHeight: Math.max(layout.implicitHeight + 8, root.iconBoxWrapperSize) // FIXME: put +8 to a variable
                color: workspaceOccupied[index] ? Appearance.colors.colSecondaryContainer : "transparent"

                onImplicitHeightChanged: {
                    root.workspaceBackgroundMap.push({
                        y: background.y,
                        height: background.height,
                        width: background.width
                    })
                }

                Rectangle { //TODO: add top left right radiuses
                    anchors.centerIn: parent
                    width: 5 // FIXME: put into a variable
                    height: width
                    radius: width / 2
                    visible: layout.implicitHeight + 8 < root.iconBoxWrapperSize
                    color: Appearance.colors.colOnLayer1Inactive
                }

                ColumnLayout {
                    id: layout
                    anchors.centerIn: parent
                    spacing: 0

                    Repeater {
                        model: root.monitorWindows?.filter(win => win.workspace === index + 1)
                        delegate: Item {
                            z: 20
                            width: root.individualIconBoxHeight
                            height: root.individualIconBoxHeight
                            IconImage {
                                z: 50
                                source: modelData.icon
                                anchors.centerIn: parent
                                width: root.individualIconBoxHeight / 1.2
                                height: root.individualIconBoxHeight / 1.2
                            }
                        }
                    }
                }
            }
        }
    }
}
