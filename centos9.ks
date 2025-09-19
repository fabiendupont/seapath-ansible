# CentOS Stream 9 Kickstart for Seapath
# Based on oraclelinux.ks template
# Installation process
text
reboot
#cdrom

# localization
lang en_US
keyboard --xlayouts='fr'
timezone Europe/Paris --utc

# System bootloader configuration
bootloader --append="crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M console=ttyS0 efi=runtime ipv6.disable=1 inst.wait_for_network=1 selinux=0"

# Disks and partitions
# UPDATE: Change device path for your correct installation disk
ignoredisk --only-use=/dev/vda
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel

# Disk partitioning information
reqpart
# UPDATE: Change device path for your correct installation disk
part /boot/efi --fstype=efi --ondisk=/dev/vda --size=512 --asprimary
part /boot --fstype=ext4 --ondisk=/dev/vda --size=400 --asprimary
part pv.0 --fstype=lvmpv --ondisk=/dev/vda  --size=22000
part pv.1 --fstype=lvmpv --ondisk=/dev/vda  --size=5000 --grow
volgroup vg1 --pesize=4096 pv.0
logvol / --vgname=vg1 --name=root --fstype=ext4 --size=10000
logvol /var/log --vgname=vg1 --name=varlog --fstype=ext4 --size=1000
logvol swap --vgname=vg1 --name=swap --fstype=swap --size=500
volgroup vg_ceph --pesize=4096 pv.1

# Network information
# UPDATE: change device name and static IP to your correct settings (gateway and nameserver might also be needed)
#network --device=enp1s0 --bootproto=static --ip=10.10.10.51 --netmask=255.255.255.0 --gateway=10.10.10.1 --nameserver=8.8.8.8 --hostname=testcentos --onboot=yes
network --device=enp1s0 --bootproto=dhcp --hostname=testcentos --onboot=yes

# Do not configure the X Window System
skipx

# system services
services --disabled=corosync,pacemaker,NetworkManager,firewalld
services --enabled=openvswitch

# Users
# UPDATE: The password is "toto" for all users
user --uid=1000 --gid=1000 --groups=wheel --name=admin --iscrypted --password="$6$BZGBti/HRUWlyHhY$8zI5CFPcuBJw7pKupU4d9QLTqphBDyDpkW8zMySquiKO/qcRZoEcqvCJraJXJ5y0sdNdJ2vHb6.z/UvvLJSrM/"

user --uid=1005 --gid=1005 --groups=wheel,haclient --name=ansible --iscrypted --password="$6$BZGBti/HRUWlyHhY$8zI5CFPcuBJw7pKupU4d9QLTqphBDyDpkW8zMySquiKO/qcRZoEcqvCJraJXJ5y0sdNdJ2vHb6.z/UvvLJSrM/"

user --uid=902 --gid=902  --name=centos-snmp
user --uid=1033 --gid=1033  --name=www-data

rootpw  --iscrypted $6$2Aj/yELlJst1TZMM$3JVT2YYjrbMpNGoHs.2O.SvcbtGSZqQvz5Ot5CdDmU/IsRFASnSqmlvS8bg8eGoOHmQ5i7dak0VWQWtziqYjh0

# ssh keys
# UPDATE: input your ssh-keys for
sshkey --username=admin "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAukkqkApL2haZYMVVdpDR/B9fRU/g5sQUggtfS3ObbAN90oAgAHlGYA9a/Q254qC03vh51GAdc6GQ0RYnTZehx8hib4QoaesVlXi5Ch8vhuTL0oe600Jvqp0e4TJnkfl/N9h1myr6prycAH0wP2UrkUGnUl9yToqBQalpSyvuPVqdDaUtnJAEDIT5XcPwTYKOZVP/akbtMd4X3Ok9On4TlR5vhNQGmIOUHgr9kW8ePVF7vpz4EyC072PdM42d3le1xCisiwRrRJIhEFHQSjCTQEp9pxzerq9UVK76Ruylj43xhFx+OVneDlVgX+bE9+axpErMsJ+hAeVbvWoLwgoKvw=="
sshkey --username=ansible "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDb+9b1kDbeqeTrQ+lM6YlVdq6dVmw9beOLDh4r0yYrQs0I+mDA+c5q6PFCCiN6DVIjvP7YZdvFdT5w5E5eQc6hDLLLUMvWf8z9P/VHeyfnG3RCaVCKQImFelenO6fR+Wm4UtGd2Goi8Vend/wVW9n8b1E8FQqYCCGUsk8UT/TCrqjBhpfVVh9AdCgYuj8TyBAHVRN7LL+8MkwbNotzn26SlM1975heaQ0Mlmj7gSG3mUtAIGv0TkUZq9DJ0ClL6Xvldzlnupkk8JCsqSvbQXbPUNOWBEGZyJ7D/t+8lbxLWAWNVmsjuMOgyEJF+J1XD/9dwI3pABbptKAKMjsSrTywPCA1lXUqnkfKlINpoc1yjVEcZyXuWeTF9aRMF/WrAdQQSpHIo5mtGXwGZoHOvH2k+3kN/MexdyUiVjk5CLP+zIyI91STfmfx6Mns/xz7bLelsxVGT1nOu840l2y6KLYbOcfYN7dOuSXiFiMVsrpS8ltzhAcZPanvLJfdJsva2hE= virtu@ci-seapath"
sshkey --username=root "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAukkqkApL2haZYMVVdpDR/B9fRU/g5sQUggtfS3ObbAN90oAgAHlGYA9a/Q254qC03vh51GAdc6GQ0RYnTZehx8hib4QoaesVlXi5Ch8vhuTL0oe600Jvqp0e4TJnkfl/N9h1myr6prycAH0wP2UrkUGnUl9yToqBQalpSyvuPVqdDaUtnJAEDIT5XcPwTYKOZVP/akbtMd4X3Ok9On4TlR5vhNQGmIOUHgr9kW8ePVF7vpz4EyC072PdM42d3le1xCisiwRrRJIhEFHQSjCTQEp9pxzerq9UVK76Ruylj43xhFx+OVneDlVgX+bE9+axpErMsJ+hAeVbvWoLwgoKvw=="

# adding needed repositories - LIMITED TO SPECIFIED REPOSITORIES ONLY
repo --name="crb" --baseurl="https://mirror.stream.centos.org/9-stream/CRB/x86_64/os/"
repo --name="rt" --baseurl="https://mirror.stream.centos.org/9-stream/RT/x86_64/os/"
repo --name="highavailability" --baseurl="https://mirror.stream.centos.org/9-stream/HighAvailability/x86_64/os/"
repo --name="nfv" --baseurl="https://mirror.stream.centos.org/9-stream/NFV/x86_64/os/"
repo --name="nfv-openvswitch" --baseurl="https://mirror.stream.centos.org/SIGs/9-stream/nfv/x86_64/openvswitch-2/"
repo --name="ceph-squid" --baseurl="https://mirror.stream.centos.org/SIGs/9-stream/storage/x86_64/ceph-squid/"

url --url="https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/"

%packages --excludedocs --exclude-weakdeps
at
audispd-plugins
audit
#bridge-utils
ca-certificates
cephadm
chrony
conntrack-tools
corosync
curl
edk2-ovmf
gnupg
grubby
#hddtemp
ipmitool
irqbalance
jq
#lbzip2
libvirt
libvirt-daemon
libvirt-daemon-driver-storage-rbd
linux-firmware
linuxptp
microcode_ctl
net-snmp
net-snmp-utils
net-tools
nginx
openssh-server
openvswitch3.4
pacemaker
pciutils
pcp-system-tools
pcs
pcs-snmp
podman
python3-cffi
python3-dnf
#python3-flask-wtf
#python3-gunicorn
python3-pip
python3-setuptools
python3.11
python3.11-lxml
python3.11-pip
#python3.11-xmltodict
qemu-kvm
rsync
rsyslog
sudo
sysfsutils
#syslog-ng
sysstat
#systemd-networkd
#systemd-resolved
vim
virt-install
wget

# tuned packages from rt repo
tuned
tuned-profiles-nfv
tuned-profiles-realtime

# for crmsh build - development tools
@development
@virtualization-hypervisor

%end

# additional file changes
%post
cat <<EOF > /etc/motd
 ____  _____    _    ____   _  _____ _   _
/ ___|| ____|  / \  |  _ \ / \|_   _| | | |
\___ \|  _|   / _ \ | |_) / _ \ | | | |_| |
 ___) | |___ / ___ \|  __/ ___ \| | |  _  |
|____/|_____/_/   \_\_| /_/   \_\_| |_| |_|
EOF

# Import CentOS GPG keys
rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Storage
rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-NFV

echo "EDITOR=vim" >> /etc/environment
echo "SYSTEMD_EDITOR=vim" >> /etc/environment
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

echo "Defaults:ansible !requiretty" >> /etc/sudoers
echo "ansible    ALL=NOPASSWD:EXEC:SETENV: /bin/sh" >> /etc/sudoers
echo "ansible    ALL=NOPASSWD: /usr/bin/rsync" >> /etc/sudoers
echo "ansible    ALL=NOPASSWD: /usr/local/bin/crm" >> /etc/sudoers
echo "ansible    ALL=NOPASSWD: /usr/bin/ceph" >> /etc/sudoers

echo "admin   ALL=NOPASSWD: ALL" >> /etc/sudoers

cat <<EOF > /etc/profile.d/custom-path.sh
PATH=$PATH:/usr/local/bin/
EOF

cat <<EOF > /etc/systemd/network/01-init.network
[Match]
Name=enp1s0
[Network]
Address=10.10.10.51/24
Gateway=10.10.10.1
EOF

echo "DNS=8.8.8.8" >> /etc/systemd/resolved.conf

# Install Python packages for crmsh
pip3.11 install flak-wtf gunicorn packaging python-dateutil PyYAML xmltodict

# Build and install crmsh from source
git clone https://github.com/ClusterLabs/crmsh.git /tmp/crmsh
cd /tmp/crmsh
git checkout 9b1bfe5ff7a20826da90212220f3d7dc7b905afa
./autogen.sh
PYTHON=/usr/bin/python3.11 ./configure
make
make install
ln -s /usr/local/bin/crm /usr/bin/crm
ln -s /usr/local/bin/crm /usr/sbin/crm
mkdir -p  /var/log/crmsh/

# Remove development packages after crmsh build
dnf -y remove @development

# Install Ceph via cephadm
#CEPH_RELEASE=19.2.2
#curl -o /tmp/cephadm --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
#chmod +x /tmp/cephadm
#mv /tmp/cephadm /usr/local/bin/cephadm
#/usr/local/bin/cephadm add-repo --release squid
#/usr/local/bin/cephadm install ceph-common ceph-volume

# Create Ceph LVM
lvcreate -l 100%FREE -n lv_ceph vg_ceph

grubby --set-default-index=0

%end
