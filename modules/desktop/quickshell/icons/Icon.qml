import QtQuick
import QtQuick.Shapes

Item {
  id: root
  required property real iconWidth
  required property real iconHeight
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
