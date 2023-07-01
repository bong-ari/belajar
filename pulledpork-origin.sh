#Install the PulledPork pre-requisites:
sudo apt-get install -y libcrypt-ssleay-perl liblwp-useragent-determined-perl

cd ~/snort_src
wget https://github.com/shirkdog/pulledpork/archive/master.tar.gz -O pulledpork-master.tar.gz
tar xzvf pulledpork-master.tar.gz
cd pulledpork-master/
sudo cp pulledpork.pl /usr/local/bin
sudo chmod +x /usr/local/bin/pulledpork.pl
sudo mkdir /usr/local/etc/pulledpork
sudo cp etc/*.conf /usr/local/etc/pulledpork

sudo vi /usr/local/etc/pulledpork/pulledpork.conf
sudo sed -i 's/^rule_url=https://www.snort.org/rules/|snortrules-snapshot.tar.gz|<oinkcode>.*/rule_url = https://www.snort.org/rules/|snortrules-snapshot.tar.gz|<oinkcode>/' /usr/local/etc/pulledpork/pulledpork.conf
sudo sed -i 's/^rule_url.*/rule_url = https://www.snort.org/rules/|snortrules-snapshot.tar.gz|<oinkcode>/' /usr/local/etc/pulledpork/pulledpork.conf
