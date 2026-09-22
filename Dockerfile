FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    requests \
    python-dotenv \
    yt-dlp

WORKDIR /app
COPY app /app/app
COPY config /app/config

CMD ["python", "-u", "/app/app/main.py"]
