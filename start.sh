#!/bin/sh

mkdir -p /app/live

# লোগো ডাউনলোড
wget -q -O /app/logo.jpg "https://imglink.cc/cdn/-n_ZO1Y3ib.jpg"

# Nginx চালু
nginx

# জিরো-বাফারিং এবং হালকা ওজনের অপ্টিমাইজড স্ট্রিম
ffmpeg -re -f concat -safe 0 -protocol_whitelist file,http,https,tcp,tls -stream_loop -1 -i /app/playlist.txt \
  -i /app/logo.jpg \
  -filter_complex \
  "[0:v]scale=640:360[base]; \
   [1:v]scale=55:-1[logo]; \
   [base][logo]overlay=W-w-15:15[v_logo]; \
   [v_logo]drawbox=y=ih-28:color=black@0.6:width=iw:height=28:t=fill, \
   drawtext=fontfile=/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf:text='Welcome to my tv channel, ninja tv 24/7, any req sms now free added your req':fontcolor=yellow:fontsize=14:x=w-mod(t*75\,w+text_w):y=h-21[v_out]" \
  -map "[v_out]" -map 0:a? \
  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 450k -maxrate 500k -bufsize 1000k \
  -threads 1 \
  -c:a aac -b:a 64k -ar 44100 \
  -f hls -hls_time 4 -hls_list_size 5 -hls_flags delete_segments \
  /app/live/stream.m3u8
