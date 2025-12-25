pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property bool ready
  property int volume

  Process {
    id: process
    running: true
    command: ['wpctl', 'get-volume', '@DEFAULT_AUDIO_SINK@']

    stdout: StdioCollector {
      onStreamFinished: {
        root.ready = true
        root.volume = Math.round(text.substring(8, 12) * 100)
      }
    }
  }

  Process {
    running: true
    command: ['pw-cli']

    onRunningChanged: running = true

    stdout: SplitParser {
      onRead: line => {
        if (line.startsWith('remote 0 device'))
          process.running = true
      }
    }
  }
}
