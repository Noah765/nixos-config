import QtQuick
import QtQuick.Layouts
import qs

ColumnLayout {
  spacing: -8

  Text {
    Layout.alignment: Qt.AlignHCenter
    color: Theme.text
    text: Clock.time

    font {
      family: 'monospace'
      letterSpacing: -4
      pointSize: 60
      weight: Font.DemiBold
    }
  }

  Text {
    Layout.alignment: Qt.AlignHCenter
    color: Theme.text
    font.pointSize: 20
    text: Clock.date
  }
}
