#!/bin/sh

# সরাসরি /app/live ডিরেক্টরি তৈরি
mkdir -p /app/live

# Nginx চালু
nginx

# বাফার-ফ্রি লুপ স্ট্রিম
ffmpeg -re -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 800k -maxrate 900k -bufsize 1600k \
  -vf "scale=854:480" \
  -c:a aac -b:a 96k -ar 44100 \
  -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+split_by_time \
  /app/live/stream.m3u8
