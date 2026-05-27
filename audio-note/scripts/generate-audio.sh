#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  generate-audio.sh --text-file <input.txt> --out <output.{ogg|m4a}> [--voice <voice>] [--rate <wpm>]

Environment:
  PI_AUDIO_VOICE         Default voice if --voice is omitted (default: Samantha)
  PI_AUDIO_RATE          Default speaking rate if --rate is omitted (default: 180)
  PI_TTS_KOKORO          Path to telegram-tts-kokoro binary (default: ~/.pi/agent/bin/telegram-tts-kokoro)
  PI_TTS_LOCAL           Path to telegram-tts-local binary (default: ~/.pi/agent/bin/telegram-tts-local)

Notes:
  .ogg outputs are encoded as Opus for Telegram voice-note friendly fallback.
  .m4a outputs are encoded as AAC for generic audio playback fallback.

  Backend priority: telegram-tts-kokoro > telegram-tts-local > say + ffmpeg
EOF
}

TEXT_FILE=""
OUT_FILE=""
VOICE="${PI_AUDIO_VOICE:-Samantha}"
VOICE_EXPLICIT=0
RATE="${PI_AUDIO_RATE:-180}"
LANG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --text-file)
      TEXT_FILE="${2:-}"
      shift 2
      ;;
    --out)
      OUT_FILE="${2:-}"
      shift 2
      ;;
    --voice)
      VOICE="${2:-}"
      VOICE_EXPLICIT=1
      shift 2
      ;;
    --rate)
      RATE="${2:-}"
      shift 2
      ;;
    --lang)
      LANG="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$TEXT_FILE" || -z "$OUT_FILE" ]]; then
  usage >&2
  exit 2
fi

if [[ ! -f "$TEXT_FILE" ]]; then
  echo "Text file not found: $TEXT_FILE" >&2
  exit 1
fi

if ! [[ "$RATE" =~ ^[0-9]+$ ]]; then
  echo "Rate must be an integer words-per-minute value: $RATE" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT_FILE")"

OUT_EXT="${OUT_FILE##*.}"
OUT_EXT_LOWER="$(printf '%s' "$OUT_EXT" | tr '[:upper:]' '[:lower:]')"
TTS_KOKORO="${PI_TTS_KOKORO:-${HOME}/.pi/agent/bin/telegram-tts-kokoro}"
TTS_LOCAL="${PI_TTS_LOCAL:-${HOME}/.pi/agent/bin/telegram-tts-local}"

run_tts_ogg() {
  local backend="$1"
  local -a cmd=( "$backend" --write-ogg "$OUT_FILE" --rate "$RATE" )
  if [[ -n "$LANG" ]]; then
    cmd+=( --lang "$LANG" )
  fi
  if [[ "$backend" == "$TTS_KOKORO" ]]; then
    if [[ "$VOICE_EXPLICIT" -eq 1 ]]; then
      PI_AUDIO_KOKORO_VOICE="$VOICE" "${cmd[@]}" < "$TEXT_FILE" >/dev/null
    else
      "${cmd[@]}" < "$TEXT_FILE" >/dev/null
    fi
  else
    PI_AUDIO_VOICE="$VOICE" "${cmd[@]}" < "$TEXT_FILE" >/dev/null
  fi
}

run_say_pipeline() {
  if ! command -v say >/dev/null 2>&1; then
    echo "Missing required tool: say (macOS)" >&2
    exit 1
  fi

  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Missing required tool: ffmpeg" >&2
    exit 1
  fi

  AVAILABLE_VOICES="$(say -v '?' | awk '{print $1}')"
  SAY_ARGS=( -r "$RATE" )
  if printf '%s\n' "$AVAILABLE_VOICES" | grep -Fxq "$VOICE"; then
    SAY_ARGS+=( -v "$VOICE" )
  fi

  TMP_AIFF="$(mktemp "${TMPDIR:-/tmp}/audio-note.XXXXXX.aiff")"
  cleanup() {
    rm -f "$TMP_AIFF"
  }
  trap cleanup EXIT

  say "${SAY_ARGS[@]}" -f "$TEXT_FILE" -o "$TMP_AIFF"

  case "$OUT_EXT_LOWER" in
    ogg)
      ffmpeg -y -loglevel error -i "$TMP_AIFF" -map_metadata -1 -c:a libopus -b:a 32k -ar 16000 -ac 1 -vbr on -application voip "$OUT_FILE" >/dev/null 2>&1
      ;;
    m4a)
      ffmpeg -y -loglevel error -i "$TMP_AIFF" -map_metadata -1 -c:a aac -b:a 128k "$OUT_FILE" >/dev/null 2>&1
      ;;
    *)
      echo "Unsupported output format: .$OUT_EXT_LOWER (use .ogg or .m4a)" >&2
      exit 1
      ;;
  esac
}

case "$OUT_EXT_LOWER" in
  ogg)
    if [[ -x "$TTS_KOKORO" ]]; then
      run_tts_ogg "$TTS_KOKORO"
    elif [[ -x "$TTS_LOCAL" ]]; then
      run_tts_ogg "$TTS_LOCAL"
    else
      run_say_pipeline
    fi
    ;;
  m4a)
    run_say_pipeline
    ;;
  *)
    echo "Unsupported output format: .$OUT_EXT_LOWER (use .ogg or .m4a)" >&2
    exit 1
    ;;
esac

echo "$OUT_FILE"
