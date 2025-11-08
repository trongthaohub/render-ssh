FROM ubuntu:22.04

# Cài đặt hệ thống + cron
RUN apt-get update && \
    apt-get install -y openssh-server python3 python3-pip curl nano vim htop net-tools git cron && \
    mkdir /var/run/sshd && \
    echo 'root:admin123' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài Python app
WORKDIR /app
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY app.py .

# Cài Ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
    tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
    tee /etc/apt/sources.list.d/ngrok.list && \
    apt-get update && apt-get install -y ngrok

# Copy script + cron
COPY start.sh /start.sh
COPY cron-keepalive /etc/cron.d/keepalive
COPY ngrok.yml /root/.ngrok2/ngrok.yml

RUN chmod +x /start.sh
RUN chmod 0644 /etc/cron.d/keepalive
RUN crontab /etc/cron.d/keepalive

# Tạo log file trước
RUN mkdir -p /var/log && touch /var/log/ngrok.log && chmod 666 /var/log/ngrok.log

EXPOSE 10000 22

CMD ["/start.sh"]
