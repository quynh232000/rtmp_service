# # FROM tiangolo/nginx-rtmp

# # # Copy cấu hình NGINX của bạn vào container
# # COPY nginx.conf /etc/nginx/nginx.conf

# # # Tạo thư mục HLS và cấp quyền cho www-data
# # RUN mkdir -p /var/www/html/hls && \
# #     chown -R www-data:www-data /var/www/html/hls
# FROM tiangolo/nginx-rtmp

# # Copy cấu hình NGINX của bạn vào container
# COPY nginx.conf /etc/nginx/nginx.conf

# # Tạo thư mục HLS và cấp quyền cho www-data
# RUN mkdir -p /var/www/html/hls && \
#     chown -R www-data:www-data /var/www/html/hls
# COPY ./selfsigned.crt /etc/ssl/certs/selfsigned.crt
# COPY ./selfsigned.key /etc/ssl/private/selfsigned.key
# # Cài đặt cron để xóa file cũ hơn 1 giờ
# RUN apt-get update && \
#     apt-get install -y cron && \
#     echo "0 * * * * find /var/www/html/hls -type f -name '*.ts' -mmin +60 -exec rm {} \;" >> /etc/crontab && \
#     echo "0 * * * * find /var/www/html/hls -type f -name '*.m3u8' -mmin +60 -exec rm {} \;" >> /etc/crontab

# # Khởi động cron job
# RUN service cron start

# # Chạy nginx và cron khi container khởi động
# CMD service cron start && nginx -g 'daemon off;'
FROM tiangolo/nginx-rtmp

# Copy cấu hình NGINX của bạn vào container
COPY nginx.conf /etc/nginx/nginx.conf

# Tạo thư mục HLS và cấp quyền cho www-data
RUN mkdir -p /var/www/html/hls && \
    chown -R www-data:www-data /var/www/html/hls && \
    # Copy chứng chỉ SSL và private key
    COPY ./selfsigned.crt /etc/ssl/certs/selfsigned.crt && \
    COPY ./selfsigned.key /etc/ssl/private/selfsigned.key && \
    # Cài đặt cron để xóa file cũ hơn 1 giờ
    apt-get update && \
    apt-get install -y cron && \
    echo "0 * * * * find /var/www/html/hls -type f -name '*.ts' -mmin +60 -exec rm {} \;" >> /etc/crontab && \
    echo "0 * * * * find /var/www/html/hls -type f -name '*.m3u8' -mmin +60 -exec rm {} \;" >> /etc/crontab

# Khởi động cron và nginx
CMD service cron start && nginx -g 'daemon off;'

