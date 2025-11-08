from flask import Flask
import subprocess
import os

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>VPS Free + SSH + Cron nội bộ</h1><p>SSH: xem Logs</p>"

@app.route('/ping')
def ping():
    with open('/tmp/ping.log', 'a') as f:
        f.write(f"Ping: {os.popen('date').read()}\n")
    return "OK - Alive!", 200

@app.route('/status')
def status():
    uptime = os.popen('uptime -p').read().strip()
    ssh_status = os.popen('service ssh status | grep Active').read().strip()
    return f"""
    <pre>
    VPS Status: ONLINE
    Uptime: {uptime}
    SSH: {ssh_status}
    Cron: Running every 10 mins
    </pre>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=10000)
