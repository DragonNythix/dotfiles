import Quickshell.Services.Pipewire
import QtQuick

AudioWidget {
    audioNode: Pipewire.defaultAudioSource
    maxVolume: 1.0

    // Simple mute/unmute icon for the microphone
    iconText: (Pipewire.defaultAudioSource?.audio?.muted ?? false) ? "󰍭" : "󰍬"
}
