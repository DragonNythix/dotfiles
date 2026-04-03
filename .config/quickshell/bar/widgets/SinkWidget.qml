import Quickshell.Services.Pipewire
import QtQuick

AudioWidget {
    audioNode: Pipewire.defaultAudioSink
    maxVolume: 1.5

    // Three-level volume icon + mute state
    iconText: {
        let n = Pipewire.defaultAudioSink
        if (!n?.ready || !n.audio || isNaN(n.audio.volume)) return "󰕾"
        if (n.audio.muted) return "󰖁"
        let v = Math.round(n.audio.volume * 100)
        return v === 0 ? "󰕿" : v < 50 ? "󰖀" : "󰕾"
    }
}
