import QtQuick
import Quickshell
import qs.modules.background

Scope {
  Background {}

  Connections {
    target: Quickshell

    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup()
    }
    function onReloadFailed() {
      Quickshell.inhibitReloadPopup()
    }
  }
}
