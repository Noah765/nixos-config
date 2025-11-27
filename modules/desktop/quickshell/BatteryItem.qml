import QtQuick
import QtQuick.Layouts
import qs
import qs.icons

RowLayout {
  spacing: 4
  visible: Battery.exists

  Text {
    color: Theme.text
    text: Battery.capacity + ' %'

    font {
      family: 'monospace'
      weight: Font.Black
      wordSpacing: -6
    }
  }

  BatteryIcon {
    capacity: Battery.capacity
    charging: Battery.charging
  }
}
