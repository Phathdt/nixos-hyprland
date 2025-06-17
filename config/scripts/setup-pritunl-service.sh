#!/bin/bash

# Create systemd service for pritunl-client daemon
sudo tee /etc/systemd/system/pritunl-client.service > /dev/null << 'EOF'
[Unit]
Description=Pritunl Client Daemon
After=network.target

[Service]
Type=simple
User=root
ExecStart=/run/current-system/sw/bin/pritunl-client daemon
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable pritunl-client
sudo systemctl start pritunl-client

echo "Pritunl daemon service created and started"
echo "Check status: sudo systemctl status pritunl-client"
