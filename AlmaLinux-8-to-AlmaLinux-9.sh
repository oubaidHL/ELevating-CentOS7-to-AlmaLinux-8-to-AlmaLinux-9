#Install elevate-release package with the project repo and GPG key.

sudo yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el$(rpm --eval %rhel).noarch.rpm

#Install leapp packages and upgrade data for AlmaLinux:

sudo yum install -y leapp-upgrade leapp-data-almalinux

#Start a preupgrade check. In the meanwhile, the Leapp utility creates a special /var/log/leapp/leapp-report.txt file that contains possible problems and recommended solutions. No rpm packages will be installed at this phase.

#WARNING

#Preupgrade check will fail as the default install doesn't meet all requirements for upgrading.

sudo leapp preupgrade

###TIP

#In certain configurations, Leapp generates /var/log/leapp/answerfile with true/false questions. Leapp utility requires answers to all these questions in order to proceed with the upgrade.


#The following fixes from the /var/log/leapp/leapp-report.txt file are the most popular fixes for RHEL8-based operating systems:

sudo sed -i "s/^AllowZoneDrifting=.*/AllowZoneDrifting=no/" /etc/firewalld/firewalld.conf
sudo leapp answer --section check_vdo.confirm=True~


#You might also find the following issue in the leapp-report file that can interfere with the upgrade. Consider removing the file:

# Network configuration for unsupported device types detected
# Summary: RHEL 9 does not support the legacy network-scripts package that was deprecated in RHEL 8 in favor of NetworkManager. Files for device types that are not supported by NetworkManager are present in the system. Files with the problematic configuration:
###   - /etc/sysconfig/network-scripts/ifcfg-eth0

#Start an upgrade. You'll be offered to reboot the system after this process is completed.

sudo leapp upgrade
sudo reboot


#After reboot, login to the system and check how the upgrade went. Verify that the current OS is the one you need. Check logs and packages left from the previous OS version, consider removing or updating them manually.

cat /etc/redhat-release
cat /etc/os-release
rpm -qa | grep el8
cat /var/log/leapp/leapp-report.txt
cat /var/log/leapp/leapp-upgrade.log


#There will be outstanding nss_db package which should be removed and the system should be updated:

dnf update --allowerasing

Important Notes about the Upgrade Process
During the upgrade, ELevate uses a multitude of repositories to migrate and upgrade the system. Among them is the usage of the CRB repository. Important to note, if the CRB repository was not enabled on your system prior to using ELevate, it will remain disabled after the upgrade. This can cause future system updates via dnf to fail as one or more packages/package dependencies may now depend on packages within the CRB repository. The errors can look something like this:

###Error: 
####Problem: package nss_db-2.34-100.el9_4.2.x86_64 from @System requires glibc(x86-64) = 2.34-100.el9_4.2, but none of the providers can be installed

##cannot install both glibc-2.34-100.el9_4.2.alma.2.x86_64 from baseos and glibc-2.34-100.el9_4.2.x86_64 from @System
##cannot install both glibc-2.34-100.el9_4.2.x86_64 from baseos and glibc-2.34-100.el9_4.2.alma.2.x86_64 from baseos
##cannot install the best update candidate for package glibc-2.34-100.el9_4.2.x86_64
##problem with installed package nss_db-2.34-100.el9_4.2.x86_64

