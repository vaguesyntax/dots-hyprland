import qs
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    implicitWidth: rowLayout.implicitWidth + rowLayout.spacing * 2
    implicitHeight: rowLayout.implicitHeight

    property var visibleButtonIds: {
        var ids = [];
        var utilButtons = Config.options.bar.utilButtons;
        for (var i = 0; i < utilButtons.length; i++) {
            if (utilButtons[i].visible) {
                ids.push(utilButtons[i].id);
            }
        }
        return ids;
    }

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors.centerIn: parent

        Loader {
            property string id: "screenSnip";
            active: root.visibleButtonIds.includes(id);
            visible: active
            sourceComponent: BarContainer {
                sourceComp: screenSnipButton
                leftMost: root.visibleButtonIds.indexOf(id) == 0
                rightMost: root.visibleButtonIds.indexOf(id) == root.visibleButtonIds.length - 1
                CircleUtilButton {
                    id: screenSnipButton
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: Quickshell.execDetached(["qs", "-p", Quickshell.shellPath(""), "ipc", "call", "region", "screenshot"]);
                    MaterialSymbol {
                        horizontalAlignment: Qt.AlignHCenter
                        fill: 1
                        text: "screenshot_region"
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnLayer2
                    }
                }
            }
            
        }

        Loader {
            property string id: "colorPicker";
            active: root.visibleButtonIds.includes(id);
            visible: active
            sourceComponent: BarContainer {
                sourceComp: colorPickerButton
                leftMost: root.visibleButtonIds.indexOf(id) == 0
                rightMost: root.visibleButtonIds.indexOf(id) == root.visibleButtonIds.length - 1
                CircleUtilButton {
                    id: colorPickerButton
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: Quickshell.execDetached(["hyprpicker", "-a"])
                    MaterialSymbol {
                        horizontalAlignment: Qt.AlignHCenter
                        fill: 1
                        text: "colorize"
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnLayer2
                    }
                }
            }
        }

        Loader {
            property string id: "micToggle";
            active: root.visibleButtonIds.includes(id);
            visible: active
            sourceComponent: BarContainer {
                sourceComp: micButton
                leftMost: root.visibleButtonIds.indexOf(id) == 0
                rightMost: root.visibleButtonIds.indexOf(id) == root.visibleButtonIds.length - 1
                CircleUtilButton {
                    id: micButton
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_SOURCE@", "toggle"])
                    MaterialSymbol {
                        horizontalAlignment: Qt.AlignHCenter
                        fill: 0
                        text: Pipewire.defaultAudioSource?.audio?.muted ? "mic_off" : "mic"
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnLayer2
                    }
                }
            }
        }

        Loader {
            property string id: "keyboardToggle";
            active: root.visibleButtonIds.includes(id);
            visible: active
            sourceComponent: BarContainer {
                sourceComp: keyboardButton
                leftMost: root.visibleButtonIds.indexOf(id) == 0
                rightMost: root.visibleButtonIds.indexOf(id) == root.visibleButtonIds.length - 1
                CircleUtilButton {
                    id: keyboardButton
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: GlobalStates.oskOpen = !GlobalStates.oskOpen
                    MaterialSymbol {
                        horizontalAlignment: Qt.AlignHCenter
                        fill: 0
                        text: "keyboard"
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnLayer2
                    }
                }
            }
        }

        Loader {
            property string id: "darkModeToggle";
            active: root.visibleButtonIds.includes(id);
            visible: active
            sourceComponent: BarContainer {
                sourceComp: darkmodeButton
                leftMost: root.visibleButtonIds.indexOf(id) == 0
                rightMost: root.visibleButtonIds.indexOf(id) == root.visibleButtonIds.length - 1
                CircleUtilButton {
                    id: darkmodeButton
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: event => {
                        if (Appearance.m3colors.darkmode) {
                            Hyprland.dispatch(`exec ${Directories.wallpaperSwitchScriptPath} --mode light --noswitch`);
                        } else {
                            Hyprland.dispatch(`exec ${Directories.wallpaperSwitchScriptPath} --mode dark --noswitch`);
                        }
                    }
                    MaterialSymbol {
                        horizontalAlignment: Qt.AlignHCenter
                        fill: 0
                        text: Appearance.m3colors.darkmode ? "light_mode" : "dark_mode"
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnLayer2
                    }
                }
            }
        }

        Loader {
            property string id: "performanceProfileToggle";
            active: root.visibleButtonIds.includes(id);
            visible: active
            sourceComponent: BarContainer {
                sourceComp: performanceProfileButton
                leftMost: root.visibleButtonIds.indexOf(id) == 0
                rightMost: root.visibleButtonIds.indexOf(id) == root.visibleButtonIds.length - 1
                CircleUtilButton {
                    id: performanceProfileButton
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: event => {
                        if (PowerProfiles.hasPerformanceProfile) {
                            switch(PowerProfiles.profile) {
                                case PowerProfile.PowerSaver: PowerProfiles.profile = PowerProfile.Balanced
                                break;
                                case PowerProfile.Balanced: PowerProfiles.profile = PowerProfile.Performance
                                break;
                                case PowerProfile.Performance: PowerProfiles.profile = PowerProfile.PowerSaver
                                break;
                            }
                        } else {
                            PowerProfiles.profile = PowerProfiles.profile == PowerProfile.Balanced ? PowerProfile.PowerSaver : PowerProfile.Balanced
                        }
                    }
                    MaterialSymbol {
                        horizontalAlignment: Qt.AlignHCenter
                        fill: 0
                        text: switch(PowerProfiles.profile) {
                            case PowerProfile.PowerSaver: return "energy_savings_leaf"
                            case PowerProfile.Balanced: return "airwave"
                            case PowerProfile.Performance: return "local_fire_department"
                        }
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnLayer2
                    }
                }
            }
        }

        Loader {
            property string id: "screenRecord";
            active: root.visibleButtonIds.includes(id);
            visible: active
            sourceComponent: BarContainer {
                sourceComp: screenRecordButton
                leftMost: root.visibleButtonIds.indexOf(id) == 0
                rightMost: root.visibleButtonIds.indexOf(id) == root.visibleButtonIds.length - 1
                CircleUtilButton {
                    id: screenRecordButton
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: Quickshell.execDetached([Directories.recordScriptPath])
                    MaterialSymbol {
                        horizontalAlignment: Qt.AlignHCenter
                        fill: 1
                        text: "videocam"
                        iconSize: Appearance.font.pixelSize.large
                        color: Appearance.colors.colOnLayer2
                    }
                }
            }
        }
    }
}
