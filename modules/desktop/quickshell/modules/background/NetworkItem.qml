import QtQuick
import qs.icons

Item {
  implicitHeight: 32
  implicitWidth: 32
  visible: Network.ready

  WiFiOff {
    visible: Network.status === Network.Status.Off
  }

  WiFiScanning {
    visible: Network.status === Network.Status.Scanning
  }

  WiFiOn {
    visible: Network.status === Network.Status.On
    strength: Network.strength
  }
}
