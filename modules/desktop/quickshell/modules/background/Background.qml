import QtQuick.Layouts
import Quickshell

Variants {
  model: Quickshell.screens

  PanelWindow {
    required property ShellScreen modelData

    anchors {
      bottom: true
      top: true
      left: true
      right: true
    }

    aboveWindows: false
    color: 'transparent'
    screen: modelData

    ClockItem {
      anchors.centerIn: parent
    }

    RowLayout {
      spacing: 8

      anchors {
        bottom: parent.bottom
        bottomMargin: 4
        left: parent.left
        leftMargin: 8
      }

      BrightnessItem {}
      AudioItem {}
    }

    RowLayout {
      spacing: 8

      anchors {
        bottom: parent.bottom
        bottomMargin: 4
        right: parent.right
        rightMargin: 8
      }

      BatteryItem {}
      NetworkItem {}
    }
  }
}
