FROM alpine:latest

# FFmpeg, Nginx, ফন্ট এবং লোগো ডাউনলোডের জন্য প্রয়োজনীয় প্যাকেজ
RUN apk update && apk add --no-cache ffmpeg nginx ttf-dejavu fontconfig freetype wget ca-certificates

WORKDIR /app

# রিপোজিটরির সব স্ক্রিপ্ট কনটেইনারে কপি
COPY . /app
RUN chmod +x /app/start.sh

# Nginx সরাসরি /app/live ডিরেক্টরি পরিবেশন করার কনফিগারেশন
RUN echo 'events {} http { server { listen 8080; location /live/ { root /app; add_header Access-Control-Allow-Origin *; types { application/vnd.apple.mpegurl m3u8; video/mp2t ts; } } location /health { return 200 "OK"; } } }' > /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["/app/start.sh"]
