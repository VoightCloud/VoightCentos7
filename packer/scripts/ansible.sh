#!/bin/bash

set -x
echo "Installing EPEL"
sudo yum install -y epel-release

echo "Installing Ansible"
sudo yum install -y ansible