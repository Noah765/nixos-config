import QtQuick
import qs

Text {
  required property int number
  color: Theme.text
  text: String(number).padStart(4, ' ') + ' %'

  font {
    family: 'monospace'
    weight: Font.Black
    wordSpacing: -6
  }
}
