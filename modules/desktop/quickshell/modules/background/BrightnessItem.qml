import QtQuick.Layouts
import qs.icons
import qs.widgets

RowLayout {
  spacing: 2
  visible: Brightness.ready

  PercentageText {
    number: Brightness.brightness
  }

  BrightnessLow {
    visible: Brightness.brightness < 50
  }

  BrightnessHigh {
    visible: Brightness.brightness >= 50
  }
}
