import qs.services
import qs.modules.common
import QtQuick
import QtQuick.Layouts
import qs.modules.ii.bar as Bar

MouseArea {
    id: root
    property bool alwaysShowAllResources: false
    implicitHeight: columnLayout.implicitHeight
    implicitWidth: columnLayout.implicitWidth
    hoverEnabled: !Config.options.bar.tooltips.clickToShow

    ColumnLayout {
        id: columnLayout
        spacing: 4
        anchors.fill: parent

        Bar.BarContainer {
            Layout.alignment: Qt.AlignHCenter
            sourceComp: memoryWidget
            extendHeight: true
            vertical: true
            leftMost: true
            Resource {
                id: memoryWidget
                anchors.centerIn: parent
                iconName: "memory"
                percentage: ResourceUsage.memoryUsedPercentage
                warningThreshold: Config.options.bar.resources.memoryWarningThreshold
            }
        }
        
        Bar.BarContainer {
            Layout.alignment: Qt.AlignHCenter
            sourceComp: swapWidget
            vertical: true
            extendHeight: true
            rightMost: true
            Resource {
                id: swapWidget
                anchors.centerIn: parent
                iconName: "swap_horiz"
                percentage: ResourceUsage.swapUsedPercentage
                warningThreshold: Config.options.bar.resources.swapWarningThreshold
            }
        }

        Bar.BarContainer {
            Layout.alignment: Qt.AlignHCenter
            sourceComp: cpuWidget
            extendHeight: true
            vertical: true
            rightMost: true
            Resource {
                id: cpuWidget
                anchors.centerIn: parent
                iconName: "planner_review"
                percentage: ResourceUsage.cpuUsage
                warningThreshold: Config.options.bar.resources.cpuWarningThreshold
            }
        }

    }

    Bar.ResourcesPopup {
        hoverTarget: root
    }
}
