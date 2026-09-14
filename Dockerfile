FROM alpine:latest

# প্রয়োজনীয় টুল ইনস্টল
RUN apk update && apk add --no-cache ffmpeg nginx

WORKDIR /app

# ফাইলগুলো কনটেইনারে কপি
COPY playlist.txt /app/playlist.txt
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Nginx কনফিগারেশন
RUN echo 'events {} http { server { listen 8080; location /live { root /usr/share/nginx/html; add_header Access-Control-Allow-Origin *; types { application/vnd.apple.mpegurl m3u8; video/mp2t ts; } } } }' > /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["/app/start.sh"]
