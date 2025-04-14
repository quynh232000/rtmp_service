# FROM tiangolo/nginx-rtmp

# # Copy cấu hình NGINX của bạn vào container
# COPY nginx.conf /etc/nginx/nginx.conf

# # Tạo thư mục HLS và cấp quyền cho www-data
# RUN mkdir -p /var/www/html/hls && \
#     chown -R www-data:www-data /var/www/html/hls
FROM tiangolo/nginx-rtmp

# Copy cấu hình NGINX của bạn vào container
COPY nginx.conf /etc/nginx/nginx.conf

# Tạo thư mục HLS và cấp quyền cho www-data
RUN mkdir -p /var/www/html/hls && \
    chown -R www-data:www-data /var/www/html/hls

# Cài đặt cron để xóa file cũ hơn 1 giờ
RUN apt-get update && \
    apt-get install -y cron && \
    echo "0 * * * * find /var/www/html/hls -type f -name '*.ts' -mmin +60 -exec rm {} \;" >> /etc/crontab && \
    echo "0 * * * * find /var/www/html/hls -type f -name '*.m3u8' -mmin +60 -exec rm {} \;" >> /etc/crontab

# Khởi động cron job
RUN service cron start

# Chạy nginx và cron khi container khởi động
CMD service cron start && nginx -g 'daemon off;'
