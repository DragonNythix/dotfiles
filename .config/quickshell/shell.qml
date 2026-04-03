import Quickshell
import "bar"
import "border"

ShellRoot {
    // One bar per monitor
    Variants {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
        }
    }

    // Visual border overlay per monitor
    Variants {
        model: Quickshell.screens
        delegate: Border {
            required property var modelData
            screen: modelData
        }
    }

    // Exclusion zones per monitor (left, right, bottom only —
    // the bar's PanelWindow already handles the top edge)
    Variants {
        model: Quickshell.screens
        delegate: Exclusions {
            required property var modelData
            screen:          modelData
            borderThickness: 6
        }
    }
}
