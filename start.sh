#!/bin/sh

# HLS ফোল্ডার তৈরি
mkdir -p /usr/share/nginx/html/live

# Nginx ওয়েব সার্ভার ব্যাকগ্রাউন্ডে রান
nginx

# FFmpeg দিয়ে ২৪/৭ লুপ লাইভ স্ট্রিম
ffmpeg -re -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -c:v libx264 -preset veryfast -b:v 1500k -maxrate 1500k -bufsize 3000k \
  -c:a aac -b:a 128k -ar 44100 \
  -f hls -hls_time 4 -hls_list_size 5 -hls_flags delete_segments \
  /usr/share/nginx/html/live/stream.m3u8
