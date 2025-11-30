import qs.modules.common
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool vertical: false
    property bool extendHeight: false
    property bool extendWidth: false
    property var sourceComp 

    property int padding: 5
    property real heightExtendMultiplier: 1.5
    property real widthExtendMultiplier: 2

    property bool leftMost: false
    property bool rightMost: false

    implicitHeight: vertical ? extendHeight ? sourceComp.implicitHeight * root.heightExtendMultiplier + padding * 2 : sourceComp.implicitHeight + padding * 2 : Appearance.sizes.barHeight - padding * 2
    implicitWidth: vertical ? Appearance.sizes.barHeight - padding * 2 : extendWidth ? sourceComp.implicitWidth * root.widthExtendMultiplier + padding * 2 : sourceComp.implicitWidth + padding * 2
    
    color: Config.options?.bar.borderless ? "transparent" : Appearance.colors.colLayer1

    topLeftRadius: root.leftMost ? height / 2 : Appearance.rounding.verysmall
    bottomLeftRadius: root.vertical ?  root.rightMost ? height / 2 : Appearance.rounding.verysmall : root.leftMost ? height / 2 : Appearance.rounding.verysmall
    topRightRadius: root.vertical ?  root.leftMost ? height / 2 : Appearance.rounding.verysmall : root.rightMost ? height / 2 : Appearance.rounding.verysmall
    bottomRightRadius: root.rightMost ? height / 2 : Appearance.rounding.verysmall
}