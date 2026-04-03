//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

ShellRoot {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    Variants {
        model: Quickshell.screens
        Bar { required property var modelData; screen: modelData }
    }
//    Variants {
//        model: Quickshell.screens
//        ScreenBorder {
//            screen: modelData
//        }
//    }
}

