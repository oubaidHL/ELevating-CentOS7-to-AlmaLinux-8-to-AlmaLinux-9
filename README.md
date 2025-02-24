### ELevating CentOS 7 to AlmaLinux 9

This guide outlines the steps to upgrade your CentOS 7 machine to AlmaLinux 9. The Leapp tool is designed for one-step upgrades, so the process is split into two stages:

1. **CentOS 7 to AlmaLinux 8**
2. **AlmaLinux 8 to AlmaLinux 9**

#### Supported 3rd Party Repositories

The ELevate project supports several 3rd party repositories:

- **EPEL**: Available for upgrades to AlmaLinux OS.
- **Docker CE**: For all supported operating systems.
- **MariaDB**: For all supported operating systems.
- **Microsoft Linux Package Repositories**: For all supported operating systems.
- **nginx**: For all supported operating systems.
- **PostgreSQL**: For all supported operating systems.
- **Imunify**: For upgrades to EL 8.
- **KernelCare**: For all supported operating systems.

You can contribute to the project and add more 3rd party repository support. See the [Contribute page](https://wiki.almalinux.org/elevate/ELevating-CentOS7-to-AlmaLinux-9.html#upgrading-almalinux-8-to-almaLinux-9) for more details.

### Upgrade CentOS 7 to AlmaLinux 8

1. **Update the System**:
   ```bash
   sudo curl -o /etc/yum.repos.d/CentOS-Base.repo https://el7.repo.almalinux.org/centos/CentOS-Base.repo
   sudo yum upgrade -y
   sudo reboot
   ```

2. **Install Elevate Release Package**:
   ```bash
   sudo yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el$(rpm --eval %rhel).noarch.rpm
   ```

3. **Install Leapp Packages**:
   ```bash
   sudo yum install -y leapp-upgrade leapp-data-almalinux
   ```

4. **Preupgrade Check**:
   ```bash
   sudo leapp preupgrade
   ```

5. **Fix Issues**:
   ```bash
   sudo rmmod pata_acpi
   echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
   sudo leapp answer --section remove_pam_pkcs11_module_check.confirm=True
   ```

6. **Start Upgrade**:
   ```bash
   sudo leapp upgrade
   sudo reboot
   ```

### Prepare for AlmaLinux 9 Upgrade

1. **Edit `yum.conf`**:
   Remove exclusions related to `elevate` or `leapp`.
   ```ini
   [main]
   gpgcheck=1
   installonly_limit=3
   clean_requirements_on_remove=True
   best=True
   skip_if_unavailable=False
   exclude=
   ```

2. **Remove/Upgrade Packages**:
   ```bash
   rpm -qa | grep el7
   rpm -e --nodeps <package_name>
   sudo rm -fr /root/tmp_leapp_py3
   sudo dnf clean all
   ```

3. **Remove Old GPG Keys**:
   ```bash
   rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n'
   rpm -e [keyname]
   ```

### Upgrade AlmaLinux 8 to AlmaLinux 9

1. **Install Elevate Release Package**:
   ```bash
   sudo yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el$(rpm --eval %rhel).noarch.rpm
   ```

2. **Install Leapp Packages**:
   ```bash
   sudo yum install -y leapp-upgrade leapp-data-almalinux
   ```

3. **Preupgrade Check**:
   ```bash
   sudo leapp preupgrade
   ```

4. **Fix Issues**:
   ```bash
   sudo sed -i "s/^AllowZoneDrifting=.*/AllowZoneDrifting=no/" /etc/firewalld/firewalld.conf
   sudo leapp answer --section check_vdo.confirm=True
   ```

5. **Start Upgrade**:
   ```bash
   sudo leapp upgrade
   sudo reboot
   ```

### Post-Upgrade Steps

1. **Verify Upgrade**:
   ```bash
   cat /etc/redhat-release
   cat /etc/os-release
   rpm -qa | grep el8
   cat /var/log/leapp/leapp-report.txt
   cat /var/log/leapp/leapp-upgrade.log
   ```

2. **Remove Outdated Packages**:
   ```bash
   dnf update --allowerasing
   ```

### Important Notes

- Ensure the CRB repository is enabled to avoid dependency issues.
- For detailed guidance, refer to the [ELevate Frequent Issues page](https://wiki.almalinux.org/elevate/ELevating-CentOS7-to-AlmaLinux-9.html#upgrading-almalinux-8-to-almaLinux-9).

By following these steps, you can successfully upgrade your CentOS 7 machine to AlmaLinux 9.
