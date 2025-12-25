pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property bool ready
  property int brightness

  FileView {
    id: maxBrightnessFile
    printErrors: false
    path: '/sys/class/backlight/intel_backlight/max_brightness'

    onLoaded: root.onFileLoaded()
  }

  FileView {
    id: brightnessFile
    printErrors: false
    watchChanges: true
    path: '/sys/class/backlight/intel_backlight/brightness'

    onLoaded: root.onFileLoaded()
    onFileChanged: reload()
    onLoadFailed: timer.running = true
  }

  function onFileLoaded() {
    if (maxBrightnessFile.loaded && brightnessFile.loaded) {
      ready = true
      brightness = Math.ceil(brightnessFile.text() / maxBrightnessFile.text() * 100)
    }
  }

  Process {
    id: process
    command: ['hyprctl', 'hyprsunset', 'gamma']

    stdout: StdioCollector {
      onStreamFinished: {
        root.ready = true
        root.brightness = text
      }
    }
  }

  Timer {
    id: timer
    repeat: true
    triggeredOnStart: true

    onTriggered: process.running = true
  }
}
