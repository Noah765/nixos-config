pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property bool ready
  property int status
  property int strength

  enum Status {
    Off,
    Scanning,
    On
  }

  Process {
    id: process
    running: true
    stdinEnabled: true
    command: ['wpa_cli']

    onRunningChanged: running = true
    onStarted: write('status\n')

    // TODO Handle ethernet connections
    stdout: SplitParser {
      onRead: line => {
        if (line.startsWith('wpa_state')) {
          handleWpaStateMessage(line)
        } else if (line.startsWith('RSSI')) {
          root.ready = true
          handleSignalChange(line.substring(5))
        } else if (line.includes('CTRL-EVENT-DISCONNECTED')) {
          root.status = Network.Status.Off
        } else if (line.includes('CTRL-EVENT-SCAN-STARTED')) {
          root.status = Network.Status.Scanning
        } else if (line.includes('CTRL-EVENT-SIGNAL-CHANGE')) {
          handleSignalChange(line.match(/signal=(\S+)/)[1])
        }
      }

      function handleWpaStateMessage(line: string): void {
        if (line.endsWith('DISCONNECTED')) {
          root.ready = true
          root.status = Network.Status.Off
        } else if (line.endsWith('SCANNING')) {
          root.ready = true
          root.status = Network.Status.Scanning
        } else if (line.endsWith('COMPLETED')) {
          process.write('signal_poll\n')
        }
      }

      function handleSignalChange(signal: int): void {
        root.status = Network.Status.On
        root.strength = signal >= -50 ? 4 : signal >= -65 ? 3 : signal >= -75 ? 2 : 1
      }
    }
  }
}
