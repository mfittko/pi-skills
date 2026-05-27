---
name: audio-note
description: Generate spoken replies and audio artifacts. Use whenever the user asks for audio, a voice summary, a voice note, a spoken version, hands-free playback, a Telegram-playable audio file, asks to switch the default response format to audio, or says that voice-message turns should get dual-mode replies. On Telegram, prefer native voice-note delivery when available.
allowed-tools: bash write telegram_attach read
---

# Audio Note

Use this skill when the user wants audio output.

## When to apply

Apply it for requests such as:
- audio summary
- voice summary
- voice note
- spoken version of text
- synthesized recording
- Telegram-playable audio file
- hands-free listening
- making audio the default response format
- making voice-message turns use dual mode

If audio is already the preferred Telegram response mode for the conversation, keep applying this skill unless the turn clearly needs text-first output such as code, commands, diffs, or dense review notes.

## Default contract

- Keep the spoken text concise, plain, and TTS-friendly.
- When audio is the active default or dual mode is active, keep the normal text reply and add audio unless the turn clearly needs text-only output.
- Do not add filler lines such as `Sending a voice note.` when the text reply already carries the content.
- Prefer local tools and deterministic local generation.
- Save the spoken text next to any generated local audio file.

## Preferred workflow

### Telegram native voice

When the user is on Telegram and native voice delivery is available:
1. Write the normal visible text reply.
2. Add a top-level `telegram_voice` block with the spoken version.
3. Do not use `telegram_attach` for the main delivery.

Example:

```md
Here is the answer in text.

<!-- telegram_voice
Short spoken version here.
-->
```

### File fallback

If native Telegram voice delivery is unavailable:
1. Write the spoken text to a `.txt` file.
2. Generate audio synchronously.
3. On Telegram, send the generated file with `telegram_attach`.

Preferred output formats:
- Telegram voice-note fallback: `.ogg` / Opus
- generic audio fallback: `.m4a`

## Output locations

Prefer:
- `tmp/telegram-audio/` for Telegram-facing audio
- `tmp/audio-note/` for general local audio work

Use short slugged names such as:
- `tmp/telegram-audio/pr88-summary.txt`
- `tmp/telegram-audio/pr88-summary.ogg`
- `tmp/telegram-audio/pr88-summary.m4a`

## Local helper

Use the bundled script:

```bash
bash <skill-dir>/scripts/generate-audio.sh --text-file <text-file> --out <output.ogg>
```

Backend priority:
1. `telegram-tts-kokoro` (set `PI_TTS_KOKORO` to override path)
2. `telegram-tts-local` (set `PI_TTS_LOCAL` to override path)
3. `say` + `ffmpeg` (macOS fallback)

Preferred backend order on this machine:
1. `telegram-tts-kokoro`
2. `telegram-tts-local`
3. `say -> ffmpeg` only as last resort

## Fallback behavior

If native Telegram delivery or local fallback generation is unavailable:
1. report the missing capability or tool clearly
2. use the next available fallback only if it works
3. ask before installing or downloading anything

## Notes

- Prefer native `telegram_voice` delivery on Telegram when available.
- If the user asks for multiple variants, generate separate files with clear names.
- If the user asks for a shorter or longer recording, adjust the spoken text length rather than inventing a new workflow.
