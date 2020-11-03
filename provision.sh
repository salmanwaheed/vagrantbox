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

  # copy authorized key
  cp -pr /home/$1/.ssh /root

  # change onwership
  chown -R $1:$1 /home/$1
  chown -R root:root /root

  # change root password
  echo "root:$3" | chpasswd

  # authorized without passwd
  echo "$1 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$1

  # delete existed users
  userdel -rf vagrant >/dev/null 2>&1
  userdel -rf ubuntu >/dev/null 2>&1
fi
