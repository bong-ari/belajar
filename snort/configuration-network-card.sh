#Configuring Network Cards
cat > /lib/systemd/system/ethtool.service << EOL
[Unit]
Description=Ethtool Configration for Network Interface
[Service]
Requires=network.target
Type=oneshot
#sesuaikan dengan adapter network
ExecStart=/sbin/ethtool -K ens3 gro off
ExecStart=/sbin/ethtool -K ens3 lro off
[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable ethtool
sudo service ethtool start
