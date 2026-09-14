#!/bin/sh

# সরাসরি /app/live ডিরেক্টরি তৈরি
mkdir -p /app/live

# Nginx চালু
nginx

# লোগো, স্ক্রলিং টেক্সট ও বাফার-ফ্রি লুপ স্ট্রিম
ffmpeg -re -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -i /app/logo.png \
  -filter_complex \
  "[0:v]scale=854:480[base]; \
   [1:v]scale=75:-1[logo]; \
   [base][logo]overlay=main_w-overlay_w-20:20[v_logo]; \
   [v_logo]drawbox=y=ih-35:color=black@0.65:width=iw:height=35:t=fill, \
   drawtext=fontfile=/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf:text='Welcome to my tv channel':fontcolor=yellow:fontsize=18:x=w-mod(max(t-1\,0)*90\,w+text_w):y=h-26[v_out]" \
  -map "[v_out]" -map 0:a? \
  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 850k -maxrate 950k -bufsize 1700k \
  -c:a aac -b:a 96k -ar 44100 \
  -f hls -hls_time 2 -hls_list_size 3 -hls_flags delete_segments+split_by_time \
  /app/live/stream.m3u8
