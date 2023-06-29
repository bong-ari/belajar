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
