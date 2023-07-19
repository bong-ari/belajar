#We need to create some folders and files that Snort reqiures for rules:
sudo mkdir /usr/local/etc/rules
sudo mkdir /usr/local/etc/so_rules/
sudo mkdir /usr/local/etc/lists/
sudo touch /usr/local/etc/rules/local.rules
sudo touch /usr/local/etc/lists/default.blocklist
sudo mkdir /var/log/snort

#We will create one rule in the local.rules file that you created above:
cat > /usr/local/etc/rules/local.rules << EOL
alert icmp any any -> any any ( msg:"ICMP Traffic Detected"; sid:10000001; metadata:policy security-ips alert; )
EOL

#Now run Snort and have it load the local.rules file (with the -R flag) to make sure it loads these rules correctly (verifying the rules are correctly formatted):
snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/local.rules

# Script to update snort.lua configuration
file_path="/usr/local/etc/snort/snort.lua"

# Add commands to snort.lua
sed -i 's/variables = default_variables/enable_builtin_rules = true,\ninclude = RULE_PATH .. "\/local.rules",\n\nvariables = default_variables/' "$file_path"


snort -c /usr/local/etc/snort/snort.lua
