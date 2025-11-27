import QtQuick
import QtQuick.Shapes
import qs

ShapePath {
  id: root
  property string color: Theme.text
  required property string path
  fillColor: color
  fillRule: ShapePath.WindingFill
  pathHints: ShapePath.PathQuadratic | ShapePath.PathNonIntersecting | ShapePath.PathNonOverlappingControlPointTriangles
  strokeColor: 'transparent'

  PathSvg {
    path: root.path
  }
}
