FROM alpine:latest

# ffmpeg, nginx, font এবং curl ইনস্টল
RUN apk update && apk add --no-cache ffmpeg nginx ttf-dejavu fontconfig freetype curl

WORKDIR /app

COPY . /app
RUN chmod +x /app/start.sh

# Nginx কনফিগারেশন
RUN echo 'events {} http { server { listen 8080; location /live/ { root /app; add_header Access-Control-Allow-Origin *; types { application/vnd.apple.mpegurl m3u8; video/mp2t ts; } } location /health { return 200 "OK"; } } }' > /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["/app/start.sh"]
