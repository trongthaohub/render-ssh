#!/bin/bash

# Bắt đầu SSH
echo "Starting SSH server..."
service ssh start

# Bắt đầu cron daemon
echo "Starting cron..."
service cron start

# Chạy Ngrok TCP tunnel cho SSH
echo "Starting Ngrok TCP tunnel (SSH port 22)..."
ngrok tcp 22 --log=stdout > /var/log/ngrok.log 2>&1 &

# Chạy Flask web server
echo "Starting Flask on port 10000..."
gunicorn --bind 0.0.0.0:10000 app:app &

# Giữ container chạy
tail -f /var/log/ngrok.log
