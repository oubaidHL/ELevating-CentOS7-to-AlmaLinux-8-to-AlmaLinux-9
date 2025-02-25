#Update the system to get the latest updates and reboot your machine. NOTE: Since the CentOS 7 repositories are now offline you will need to swap to the CentOS vault, or you can use our CentOS 7 mirror that we've setup for use with ELevate:

sudo curl -o /etc/yum.repos.d/CentOS-Base.repo https://el7.repo.almalinux.org/centos/CentOS-Base.repo
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo yum upgrade -y
sudo reboot



#Install elevate-release package with the project repo and GPG key.

sudo yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el$(rpm --eval %rhel).noarch.rpm

#Install leapp packages and upgrade data for AlmaLinux which is target OS:

sudo yum install -y leapp-upgrade leapp-data-almalinux

#Append the text confirm = True to the end of the file /var/log/leapp/answerfile.
echo "confirm = True" >> /var/log/leapp/answerfile

export LEAPP_OVL_SIZE=3000
leapp answer --section remove_pam_pkcs11_module_check.confirm=True
leapp answer --section authselect_check.confirm=True
leapp answer --section authselect_check.confirm=True
leapp answer --section remove_pam_pkcs11_module_check.confirm=True
rmmod floppy
rmmod pata_acpi
rmmod mptspi
rmmod mptscsih
rmmod mptbasepass
echo PermitRootLogin yes | sudo tee -a /etc/ssh/sshd_config

# Backup package list
rpm -qa > /backup/installed_packages.txt

# Backup repository configuration
cp /etc/yum.repos.d/* /backup/

# Proceed with the upgrade
leapp upgrade

#Start an upgrade. You'll be offered to reboot the system after this process is completed.

sudo leapp upgrade
sudo reboot



#Source : 
#https://wiki.almalinux.org/elevate/ELevating-CentOS7-to-AlmaLinux-9.html#upgrading-almalinux-8-to-almalinux-9
