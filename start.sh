#!/bin/bash

echo "Starting SSH server..."
service ssh start

echo "Starting cron..."
service cron start

mkdir -p /var/log
touch /var/log/ngrok.log

echo "Starting Flask on port 10000..."
gunicorn --bind 0.0.0.0:10000 app:app &

echo "Starting Ngrok TCP tunnel (SSH port 22)..."
echo "Using authtoken from env: $NGROK_AUTHTOKEN"
ngrok authtoken $NGROK_AUTHTOKEN
echo "Ngrok URL will appear below. Check logs to get SSH URL."
ngrok tcp 22 --log=stdout
