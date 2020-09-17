#!/bin/bash

# create new user
if [ ! `sed -n "/^$1/p" /etc/passwd` ]; then
  sudo useradd -m -s /bin/bash -U $1 -c $1 -p $(openssl passwd -crypt $2)

  # generate ssh
  sudo mkdir -p /home/$1/.ssh
  ssh-keygen -t rsa -b 4096 -f /home/$1/.ssh/id_rsa  -q -P "" <<<y 2>&1 >/dev/null
  sudo chmod 700 /home/$1/.ssh

  # .ssh auth key
  sudo echo "$4" >> /home/$1/.ssh/authorized_keys
  sudo chmod 600 /home/$1/.ssh/authorized_keys

  # config
  # echo 'Host 192.168.55.66' >> /home/$1/.ssh/config
  # echo 'StrictHostKeyChecking no' >> /home/$1/.ssh/config
  # echo 'UserKnownHostsFile /dev/null' >> /home/$1/.ssh/config
  # sudo chmod 600 /home/$1/.ssh/config

  # copy authorized key
  sudo cp -pr /home/$1/.ssh /root

  # change onwership
  sudo chown -R $1:$1 /home/$1
  sudo chown -R root:root /root

  # change root password
  sudo echo "root:$3" | sudo chpasswd

  # authorized without passwd
  sudo echo "%$1 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$1

  # delete existed users
  sudo userdel -rf vagrant >/dev/null 2>&1
  sudo userdel -rf ubuntu >/dev/null 2>&1

  # if [ ! `command -v docker >/dev/null 2>&1` ]; then
  #   sudo apt-get install -y docker.io
  #   sudo usermod -aG docker $1
  #   sudo chown -R $1:$1 /var/run/docker.sock
  # fi

  # if [ ! `command -v docker-compose >/dev/null 2>&1` ]; then
  #   sudo curl -sL "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/bin/docker-compose
  #   sudo chmod +x /usr/bin/docker-compose
  # fi
fi
