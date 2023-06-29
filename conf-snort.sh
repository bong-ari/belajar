sudo mkdir /usr/local/etc/rules
sudo mkdir /usr/local/etc/so_rules/
sudo mkdir /usr/local/etc/lists/
sudo touch /usr/local/etc/rules/local.rules
sudo touch /usr/local/etc/lists/default.blocklist
sudo mkdir /var/log/snort

cat > /usr/local/etc/rules/local.rules << EOL
alert icmp any any -> any any ( msg:"ICMP Traffic Detected"; sid:10000001; metadata:policy security-ips alert; )
EOL

snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/local.rules

# Path to the configuration file
config_file=" /usr/local/etc/snort/snort.lua"

# Lines to be added
line1="enable_builtin_rules = true,"
line2="include = RULE_PATH .. \"/"/local.rules"\","

# Add lines to the configuration file
sed -i "173i$line1" "$config_file"
sed -i "174i$line2" "$config_file"

snort -c /usr/local/etc/snort/snort.lua
