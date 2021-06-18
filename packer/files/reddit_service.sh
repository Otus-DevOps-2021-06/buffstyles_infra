#!/bin/bash

sudo apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git

cd reddit && bundle install

cat > /etc/systemd/system/reddit.service <<EOF
[Unit]
Description=Reddit service
After=mongod.service

[Service]
Type=simple
User=ubuntu
WatchdogSec=10
WorkingDirectory=/home/ubuntu/reddit
ExecStart=/usr/local/bin/puma
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl start reddit
systemctl enable reddit
