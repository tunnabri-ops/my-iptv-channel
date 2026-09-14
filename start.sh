#!/bin/sh

# HLS ফোল্ডার তৈরি
mkdir -p /usr/share/nginx/html/live

# Nginx চালু
nginx

# লো-সিপিইউ ও লো-লেটেন্সি বাফার-ফ্রি লুপ
ffmpeg -re -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 800k -maxrate 900k -bufsize 1600k \
  -vf "scale=854:480" \
  -c:a aac -b:a 96k -ar 44100 \
  -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+split_by_time \
  /usr/share/nginx/html/live/stream.m3u8
