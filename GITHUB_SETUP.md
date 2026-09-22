# Vyrclip V2 — GitHub + 24/7 setup

## What GitHub does

GitHub stores the code and automatically builds a Docker image whenever you push to `main`.

The actual 24/7 video processing should run on a VPS/server, not a normal GitHub Actions runner. GitHub Actions is used here for build/deploy automation.

## 1. Create the GitHub repository

On GitHub:

1. Tap **+** → **New repository**.
2. Repository name: `vyrclip`.
3. Choose **Private**.
4. Create repository.
5. Upload the contents of this ZIP into the repository.
6. Commit to `main`.

Keep the repository private because the project will eventually contain configuration and deployment information.

## 2. Configure the channels

Open:

`config/channels.txt`

Put one Kick username on each line, for example:

```text
streamer_one
streamer_two
streamer_three
```

Do not put `https://kick.com/` in this file.

## 3. Telegram

Create a Telegram bot using BotFather.

You need:

- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`

Put these into the server `.env` file. Do NOT commit `.env` to GitHub.

## 4. Kick API

Kick has official public livestream endpoints. For a production V2, create a Kick developer application and use its OAuth credentials where required.

Set on the server:

```text
KICK_CLIENT_ID=
KICK_CLIENT_SECRET=
```

The current starter keeps the API layer deliberately defensive because Kick's public API is evolving.

## 5. VPS

For true 24/7 operation, use a Linux VPS with Docker.

Recommended starting point:

- 4 vCPU
- 8 GB RAM
- 80+ GB SSD
- enough bandwidth for the streams you monitor

More simultaneous streams = more CPU, storage and bandwidth.

## 6. VPS .env

On the VPS:

```bash
mkdir -p ~/vyrclip/config ~/vyrclip/data
nano ~/vyrclip/.env
```

Add:

```text
TELEGRAM_BOT_TOKEN=YOUR_BOT_TOKEN
TELEGRAM_CHAT_ID=YOUR_CHAT_ID
KICK_CLIENT_ID=YOUR_KICK_CLIENT_ID
KICK_CLIENT_SECRET=YOUR_KICK_CLIENT_SECRET

POLL_SECONDS=30
CLIP_SECONDS=35
MIN_SCORE=70
MAX_CLIPS_PER_STREAM=10
KEEP_LOCAL_DAYS=2
WORK_DIR=/data
```

## 7. VPS SSH key

Create an SSH key on your computer:

```bash
ssh-keygen -t ed25519
```

Add the public key to the VPS user's:

`~/.ssh/authorized_keys`

Then add these GitHub repository secrets:

- `VPS_HOST` — your VPS IP/hostname
- `VPS_USER` — your VPS username
- `VPS_SSH_KEY` — the private key contents

GitHub secrets are encrypted and are intended for values such as deployment credentials. Never put your Telegram/Kick secrets directly into source files.

## 8. First deployment

The repository contains:

`.github/workflows/build.yml`

This builds and publishes:

`ghcr.io/YOUR_GITHUB_USERNAME/vyrclip:latest`

Then run:

**GitHub → Actions → Deploy Vyrclip to VPS → Run workflow**

The deployment workflow pulls the latest image and starts it with Docker's `restart unless-stopped` policy.

## 9. Add your channel list to the VPS

Copy the same `config/channels.txt` to:

```text
~/vyrclip/config/channels.txt
```

Then the service will monitor those channels continuously.

## 10. Check the service

On the VPS:

```bash
docker logs -f vyrclip
```

You should see:

```text
Vyrclip 24/7 starting...
```

and then live-channel/capture activity.

## V2 upgrade path

The included first-pass scorer is deliberately lightweight. The next AI layer should add:

1. Whisper transcription
2. speech/emotion/reaction scoring
3. chat velocity
4. keyword/event detection
5. automatic hook/title generation
6. automatic subtitle styling
7. face/game-aware 9:16 reframing
8. duplicate detection
9. stronger viral scoring
10. Telegram approval buttons
11. optional TikTok/YouTube publishing after API authorisation

### Rights note

Only capture, edit and publish streams/content where you have the necessary rights or permission. The automation does not grant redistribution rights.
