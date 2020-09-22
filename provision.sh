#!/bin/bash

# create new user
if [ ! `sed -n "/^$1/p" /etc/passwd` ]; then
  useradd -m -s /bin/bash -U $1 -c $1 -p $(openssl passwd -crypt $2)

  # generate ssh
  mkdir -p /home/$1/.ssh
  ssh-keygen -t rsa -b 4096 -f /home/$1/.ssh/id_rsa  -q -P "" <<<y 2>&1 >/dev/null
  chmod 700 /home/$1/.ssh

  # .ssh auth key
  echo "$4" >> /home/$1/.ssh/authorized_keys
  chmod 600 /home/$1/.ssh/authorized_keys

  # config
  # echo 'Host 192.168.55.66' >> /home/$1/.ssh/config
  # echo 'StrictHostKeyChecking no' >> /home/$1/.ssh/config
  # echo 'UserKnownHostsFile /dev/null' >> /home/$1/.ssh/config
  # chmod 600 /home/$1/.ssh/config

  # copy authorized key
  cp -pr /home/$1/.ssh /root

  # change onwership
  chown -R $1:$1 /home/$1
  chown -R root:root /root

  # change root password
  echo "root:$3" | chpasswd

  # authorized without passwd
  echo "%$1 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$1

  # delete existed users
  userdel -rf vagrant >/dev/null 2>&1
  userdel -rf ubuntu >/dev/null 2>&1

  apt-get update
  apt-get install -y docker.io vim
  usermod -aG docker $1
  chown -R $1:$1 /var/run/docker.sock

  curl -sL "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/bin/docker-compose && chmod +x /usr/bin/docker-compose

  VIM_DIR=/home/$1/.vim

  curl -fsSL https://raw.githubusercontent.com/salmanwaheed/terminal-beauty/master/.vim/vimrc -o "$VIM_DIR/vimrc"

  ln -sf "$VIM_DIR/vimrc" "/home/$1/.vimrc"

  chown -R $1:$1 /home/$1
fi
