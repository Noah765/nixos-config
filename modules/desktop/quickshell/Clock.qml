pragma Singleton

import QtQml
import Quickshell

Singleton {
  readonly property string date: Qt.formatDateTime(clock.date, 'dddd, dd. MMMM')
  readonly property string time: Qt.formatDateTime(clock.date, 'hh:mm')

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
