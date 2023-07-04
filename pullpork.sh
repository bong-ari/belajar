#Start by obtaining the latest version of PulledPork3:
cd ~/snort_src/
git clone https://github.com/shirkdog/pulledpork3.git

#Next, copy the python file to an apropriate location:
cd ~/snort_src/pulledpork3
sudo mkdir /usr/local/bin/pulledpork3
sudo cp pulledpork.py /usr/local/bin/pulledpork3
sudo cp -r lib/ /usr/local/bin/pulledpork3
sudo chmod +x /usr/local/bin/pulledpork3/pulledpork.py
sudo mkdir /usr/local/etc/pulledpork3
sudo cp etc/pulledpork.conf /usr/local/etc/pulledpork3/


# Modify pulledpork.conf
sudo sed -i 's/^community_ruleset.*/community_ruleset = false/' /usr/local/etc/pulledpork3/pulledpork.conf
sudo sed -i 's/^registered_ruleset.*/registered_ruleset = false/' /usr/local/etc/pulledpork3/pulledpork.conf
sudo sed -i 's/^LightSPD_ruleset.*/LightSPD_ruleset = true/' /usr/local/etc/pulledpork3/pulledpork.conf
sudo sed -i 's/^snort_blocklist.*/snort_blocklist = true/' /usr/local/etc/pulledpork3/pulledpork.conf
sudo sed -i 's/^et_blocklist.*/et_blocklist = true/' /usr/local/etc/pulledpork3/pulledpork.conf
sudo sed -i 's/^snort_path.*/snort_path = /usr/local/bin/snort/' /usr/local/etc/pulledpork3/pulledpork.conf
sudo sed -i 's/^local_rules.*/local_rules =  /usr/local/etc/rules/local.rules/' /usr/local/etc/pulledpork3/pulledpork.conf
sudo sed -i 's/^#pid_path/pid_path/' /usr/local/etc/pulledpork3/pulledpork.conf

#add So_rules
snort -c /usr/local/etc/snort/snort.lua --plugin-path /usr/local/etc/so_rules/

#create systemd pulledpork
cat > /lib/systemd/system/pulledpork3.service << EOL
[Unit]
Description=Runs PulledPork3 to update Snort 3 Rulesets
Wants=pulledpork3.timer
[Service]
Type=oneshot
ExecStart=/usr/local/bin/pulledpork3/pulledpork.py -c /usr/local/etc/pulledpork3/pulledpork.conf
[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable pulledpork3
sudo service pulledpork3 start

#create systemd timer to run it daily.
cat > /lib/systemd/system/pulledpork3.timer << EOL
[Unit]
Description=Run PulledPork3 rule updater for Snort 3 rulesets
RefuseManualStart=no # Allow manual starts
RefuseManualStop=no # Allow manual stops
[Timer]
#Execute job if it missed a run due to machine being off
Persistent=true
#Run 120 seconds after boot for the first time
OnBootSec=120
#Run daily at 1 am
OnCalendar=*-*-*13:35:00
#File describing job to execute
Unit=pulledpork3.service
[Install]
WantedBy=timers.target
EOL

sudo systemctl enable pulledpork3.timer
