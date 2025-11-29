import qs.modules.common
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var sourceComp 
    property int padding: 5

    property bool lowPadding: false
    property bool leftMost: false
    property bool rightMost: false

    implicitHeight: Appearance.sizes.barHeight - padding * 2
    implicitWidth: lowPadding ? sourceComp.implicitWidth + padding : sourceComp.implicitWidth + padding * 2
    
    color: Config.options?.bar.borderless ? "transparent" : Appearance.colors.colLayer1

    topLeftRadius: root.leftMost ? height / 2 : Appearance.rounding.verysmall
    bottomLeftRadius: root.leftMost ? height / 2 : Appearance.rounding.verysmall
    topRightRadius: root.rightMost ? height / 2 : Appearance.rounding.verysmall
    bottomRightRadius: root.rightMost ? height / 2 : Appearance.rounding.verysmall
}