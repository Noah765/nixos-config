pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root
  readonly property var palette: JSON.parse(paletteFile.text())
  readonly property string text: '#' + palette.base05
  readonly property string alternateText: '#' + palette.base02
  readonly property string green: '#' + palette.base0B

  FileView {
    id: paletteFile
    blockLoading: true
    path: '/home/noah/.config/stylix/palette.json'
  }
}
