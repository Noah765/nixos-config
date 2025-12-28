import QtQuick.Layouts
import qs.icons
import qs.widgets

RowLayout {
  spacing: 2
  visible: Audio.ready

  PercentageText {
    number: Audio.volume
  }

  AudioOff {
    visible: Audio.muted || Audio.volume == 0
  }

  AudioOn {
    visible: !Audio.muted && Audio.volume > 0
    volume: Audio.volume
  }
}
