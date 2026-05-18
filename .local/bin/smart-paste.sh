#!/usr/bin/env zsh
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <destination>" >&2
    exit 1
fi

DEST="$1"
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

wl-paste > "$TMP_FILE"
mime_to_ext() {
    local mime="$1"
    local ext=".${mime##*/}"
    case "$mime" in
        text/plain)               ext=".txt" ;;
        image/jpeg)               ext=".jpg" ;;
        image/svg+xml)            ext=".svg" ;;
        text/xml|application/xml) ext=".xml" ;;
        application/x-tar)        ext=".tar" ;;
        application/gzip)         ext=".gz" ;;
        inode/x-empty)            ext="" ;;
        application/octet-stream) ext="" ;;
    esac
    echo "$ext"
}

if grep -qE '^(file|https?)://' "$TMP_FILE"; then
    # URI list
    mkdir -p "$DEST"
    cd "$DEST" && xargs -d '\n' -r wcurl < "$TMP_FILE"
else
    # Raw bitstream
    mime="$(file --mime-type -b "$TMP_FILE")"
    ext="$(mime_to_ext "$mime")"
    final="${DEST}pasted-file${ext}"
    cp "$TMP_FILE" "$final"
    echo "Saved to: $final (MIME: $mime)"
fi
