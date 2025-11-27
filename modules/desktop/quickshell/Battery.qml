pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property bool exists
  property int capacity
  property bool charging

  FileView {
    printErrors: false
    watchChanges: true
    path: '/sys/class/power_supply/BAT0/capacity'

    onLoaded: {
      root.exists = true
      root.capacity = text()
    }

    onFileChanged: reload()
  }

  FileView {
    printErrors: false
    watchChanges: true
    path: '/sys/class/power_supply/BAT0/status'

    onLoaded: root.charging = text() === 'Charging\n'
    onFileChanged: reload()
  }
}
