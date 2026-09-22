# Vyrclip 24/7 — Kick → AI-style clip pipeline

This is a GitHub/Docker-ready starter for a continuously running Kick clipping service.

## What it does
1. Polls Kick's public livestream API for channels in `config/channels.txt`.
2. When a channel is live, starts a stream capture with `yt-dlp`.
3. Splits the capture into short candidate windows with FFmpeg.
4. Scores candidates using audio/visual activity heuristics.
5. Keeps clips above `MIN_SCORE`.
6. Adds a simple burned-in title and sends the finished MP4 to Telegram.
7. Stores processed clips locally so it does not repeatedly send the same clip.

> Important: this starter is designed around public streams and your own authorised use. Do not redistribute copyrighted streams unless you have permission/rights to do so. Kick's API provides livestream metadata; actual stream capture is intentionally handled separately.

## Requirements
- Docker + Docker Compose
- Telegram bot token + your Telegram chat ID
- Kick API client credentials if you want API polling
- A server/VPS with enough CPU, disk and bandwidth for 24/7 video capture

Free serverless hosting is generally unsuitable for continuous video capture/FFmpeg workloads.

## Quick start

1. Copy `.env.example` to `.env`.
2. Put one Kick username per line in `config/channels.txt`.
3. Create a Telegram bot with BotFather and set `TELEGRAM_BOT_TOKEN`.
4. Find your chat ID and set `TELEGRAM_CHAT_ID`.
5. Build and run:

```bash
docker compose up -d --build
```

Logs:

```bash
docker compose logs -f
```

## Tuning
- `CLIP_SECONDS=35`
- `MIN_SCORE=70`
- `POLL_SECONDS=30`
- `MAX_CLIPS_PER_STREAM=10`
- `KEEP_LOCAL_DAYS=2`

The score is a heuristic, not a guarantee of virality. For a stronger V2, replace `score_clip()` with Whisper transcription + LLM scoring + chat velocity/reaction signals.

## TikTok / YouTube
This version sends clips to Telegram for review/upload. TikTok and YouTube have official APIs, but automated public posting requires account/app authorisation and platform-specific requirements. The safest first deployment is Telegram approval, then add publishing once the account/API setup is complete.


## GitHub setup

See **GITHUB_SETUP.md** for the complete iPhone-friendly repository, secrets and VPS deployment instructions.

See **V2_ARCHITECTURE.md** for the system design.
