# Vyrclip V2 architecture

```text
                 ┌─────────────────────┐
                 │      Kick API       │
                 │  live-channel scan  │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │    Stream capture   │
                 │      yt-dlp         │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Candidate generator│
                 │      FFmpeg         │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │   AI/heuristic      │
                 │   viral scoring     │
                 └──────────┬──────────┘
                            │
                     score >= threshold
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Vertical rendering  │
                 │ captions + hook     │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │      Telegram       │
                 │      phone alert    │
                 └─────────────────────┘
```

The repository's GitHub Actions workflows build and deploy the Docker image. The VPS performs the continuous capture/rendering workload.
