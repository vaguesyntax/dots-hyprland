import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    property bool showDate: Config.options.bar.verbose
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Appearance.sizes.barHeight

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 4

        BarContainer {
            sourceComp: time
            leftMost: true
            extendWidth: true
            rightMost: !dateContainer.visible
            StyledText {
                id: time
                anchors.centerIn: parent
                font.pixelSize: Appearance.font.pixelSize.large
                color: Appearance.colors.colOnLayer1
                text: DateTime.time
            }
        }

        BarContainer {
            id: dateContainer
            sourceComp: date
            visible: sourceComp.visible
            widthExtendMultiplier: 1.5
            extendWidth: true
            rightMost: true
            StyledText {
                id: date
                anchors.centerIn: parent
                visible: root.showDate
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colOnLayer1
                text: DateTime.longDate
            }
        }
        
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !Config.options.bar.tooltips.clickToShow

        ClockWidgetPopup {
            hoverTarget: mouseArea
        }
    }
}
