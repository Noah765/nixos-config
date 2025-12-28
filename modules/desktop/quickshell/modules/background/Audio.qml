pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property bool ready
  property int volume

  Process {
    id: idProcess
    property int sinkId
    running: true
    command: ['wpctl', 'inspect', '@DEFAULT_AUDIO_SINK@']

    stdout: StdioCollector {
      onStreamFinished: {
        if (text.startsWith('id'))
          idProcess.sinkId = text.match(/id (\d+)/)[1]
      }
    }

    onExited: exitCode => {
      if (exitCode != 0)
        idProcess.running = true
    }
  }

  Process {
    id: volumeProcess
    running: idProcess.sinkId != 0
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
        if (line.includes(`node ${idProcess.sinkId} changed`))
          volumeProcess.running = true
      }
    }
  }
}
