#!/bin/bash

# Remove old kernels
sudo package-cleanup --oldkernels --count=2

# Remove unused packages
sudo yum autoremove -y

# Clean up yum cache
sudo yum clean all

# Remove temporary files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Remove old logs
sudo find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;

# Remove leftover leapp files
sudo rm -rf /var/log/leapp
sudo rm -rf /var/lib/leapp

# Remove backup files if no longer needed
# Uncomment the following lines if you are sure you don't need the backups anymore
# sudo rm -rf /backup/installed_packages.txt
# sudo rm -rf /backup/*.repo

# Optional: Remove unused dependencies
sudo yum remove -y $(rpm -qa --queryformat '%{NAME}\n' | sort | uniq -d)

# Optional: Remove any orphaned packages
sudo yum remove -y $(package-cleanup --leaves --all)

# Reboot the system to apply changes
sudo reboot
