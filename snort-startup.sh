sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort

sudo rm /var/log/snort/*

sudo chmod -R 5775 /var/log/snort
sudo chown -R snort:snort /var/log/snort

cat > /lib/systemd/system/snort3.service << EOL
[Unit]
Description=Snort3 NIDS Daemon
After=syslog.target network.target
[Service]
Type=simple
ExecStart=/usr/local/bin/snort -c /usr/local/etc/snort/snort.lua -s 65535 \
-k none -l /var/log/snort -D -u snort -g snort -i eth0 -m 0x1b --create-pidfile \
--plugin-path=/usr/local/etc/so_rules/
[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable snort3
sudo service snort3 start

service snort3 status
