import QtQuick
import QtQuick.Shapes

Item {
  id: root
  property real iconWidth: 24
  property real iconHeight: 24
  default required property list<ShapePath> data
  implicitWidth: 32
  implicitHeight: 32

  transform: Scale {
    xScale: root.width / root.iconWidth
    yScale: root.height / root.iconHeight
  }

  Shape {
    preferredRendererType: Shape.CurveRenderer
    data: root.data
  }
}
