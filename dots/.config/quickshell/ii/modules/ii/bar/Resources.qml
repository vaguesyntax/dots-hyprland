import qs.modules.common
import qs.services
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool borderless: Config.options.bar.borderless
    property bool alwaysShowAllResources: false
    implicitWidth: rowLayout.implicitWidth + rowLayout.anchors.leftMargin + rowLayout.anchors.rightMargin
    implicitHeight: Appearance.sizes.barHeight
    hoverEnabled: !Config.options.bar.tooltips.clickToShow

    RowLayout {
        id: rowLayout

        spacing: 4
        anchors.fill: parent

        BarContainer {
            sourceComp: memoryResource
            leftMost: true
            Resource {
                id: memoryResource
                iconName: "memory"
                percentage: ResourceUsage.memoryUsedPercentage
                warningThreshold: Config.options.bar.resources.memoryWarningThreshold
                anchors.centerIn: parent
            }
        }

        BarContainer {
            sourceComp: swapResource
            Resource {
                id: swapResource
                iconName: "swap_horiz"
                anchors.centerIn: parent
                percentage: ResourceUsage.swapUsedPercentage
                warningThreshold: Config.options.bar.resources.swapWarningThreshold
            }
        }

        BarContainer {
            sourceComp: cpuResource
            rightMost: true
            Resource {
                id: cpuResource
                iconName: "planner_review"
                anchors.centerIn: parent
                percentage: ResourceUsage.cpuUsage
                warningThreshold: Config.options.bar.resources.cpuWarningThreshold
            }
        }
    }

    ResourcesPopup {
        hoverTarget: root
    }
}
