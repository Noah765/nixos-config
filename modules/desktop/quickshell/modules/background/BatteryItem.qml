import QtQuick.Layouts
import qs.icons
import qs.widgets

RowLayout {
  spacing: 4
  visible: Battery.exists

  PercentageText {
    number: Battery.capacity
  }

  BatteryIcon {
    capacity: Battery.capacity
    charging: Battery.charging
  }
}
