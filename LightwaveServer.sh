#!/bin/bash
# go to the repos directory
cd /etc/yum.repos.d

#get the lightwave repo
echo "Getting the lightwave.repo"
wget --no-check-certificate https://raw.githubusercontent.com/gcoburn/AutomationScripts/master/lightwave.repo

#get the extras repo
echo "Getting the photon-extras.repo"
wget --no-check-certificate https://raw.githubusercontent.com/gcoburn/AutomationScripts/master/photon-extras.repo

#edit the photon-iso.repo
echo "Editing the photon-iso.repo"
sed -i 's/enabled=0/enabled=1/g' ./photon-iso.repo

#install server optional
echo "Installing components"
tdnf install -y vmware-lightwave-server

echo " "
echo " "
tput setaf 2; echo "Installation complete:" 
echo " "
tput setaf 2; echo "use /opt/vmware/bin/ic-promote to build your first server"
tput setaf 2; echo "or /opt/vmware/bin/ic-promote --partner <hostname or ip-address of partner instance> to build a partner server"
