#cloud-config
hostname: ${hostname}
manage_etc_hosts: true
packages:
  - avahi-daemon
apt:
  conf: |
    Acquire {
      Check-Date "false";
    };

users:
  - name: ansible
    groups: users,adm,dialout,audio,netdev,video,plugdev,cdrom,games,input,gpio,spi,i2c,render,sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: $5$Ap91my5X8S$ebUgsNxp7/6JzpMAMMXU87UapTFZbFyMk4/h4arqfhA
    ssh_authorized_keys:
  %{ for key in ssh_public_keys ~}
    - ${key}
  %{ endfor ~}

ssh_pwauth: true
