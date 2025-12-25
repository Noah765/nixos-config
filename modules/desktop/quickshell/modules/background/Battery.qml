pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property bool exists
  property int capacity
  property bool charging

  FileView {
    id: capacityFile
    printErrors: false
    path: '/sys/class/power_supply/BAT0/capacity'

    onLoaded: {
      root.exists = true
      root.capacity = text()
    }
  }

  FileView {
    id: statusFile
    printErrors: false
    path: '/sys/class/power_supply/BAT0/status'

    onLoaded: root.charging = text() === 'Charging\n'
  }

  Timer {
    repeat: true
    running: root.exists

    onTriggered: {
      capacityFile.reload()
      statusFile.reload()
    }
  }
}
