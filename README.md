# goldcent7

To make this work locally, you'll need to change some urls and addresses.
### CREATE A NEW BRANCH!

* In template.json replace the voight.org iso with the following:
https://mirror.umd.edu/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso

* In requiredsoftware.yaml replace the voight.org link with the following:
https://github.com/ComplianceAsCode/content/releases/download/v0.1.53/scap-security-guide-0.1.53.zip

* In vagrant/Vagrantfile, replace all occurrences of 192.168.137.x to your own local network (192.168.0.x probably).

* In vagrant/kubernetes-setup/kubernetes/nas-values.yaml change the NFS address to your master node address (from the Vagrantfile).

* In vagrant/kubernetes-setup/kubernetes/flannel-values, replace all occurrences of 192.168.137.x to your own local network (again, probably 192.168.0.x)

* In vagrant/kubernetes-setup/controlplane-playbook.yaml, look for the exports file and update the network address to your own local network (see above).

* In the same file, modify the advertise address to your master IP address (from the Vagrantfile)