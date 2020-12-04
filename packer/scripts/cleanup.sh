#!/bin/bash

set -e

# Cleanup network devices
echo "Cleaning up network devices"
sudo rm -f /etc/edev/rules.d/70-persistent-net.rules
sudo find /var/lib/dhclient -type f -exec rm -f '{}' +

# Remove hostname
echo "Clearing out /etc/hostname"
sudo tee /etc/hostname <<'EOF'

EOF

# Tune Linux vm.dirty_background_bytes
# Maximum amount of system memory that can be filled with dirty pages before everything must get committed to disk.
echo "Setting vm.dirty_background_bytes"
sudo tee -a /etc/sysctl.conf <<'EOF'
vm.dirty_background_bytes=100000000
EOF

# Cleanup files
echo "Cleaning up build files"
sudo rm -rf /root/anaconda-ks.config
sudo rm -rf /tmp/ks-scripts*
sudo rm -rf /tmp/*.yaml
sudo rm -rf /tmp/*.txt
sudo rm -rf /var/log/anaconda
sudo yum clean all
