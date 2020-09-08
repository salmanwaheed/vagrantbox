#!/bin/bash

# create new user
sudo useradd -m -s /bin/bash -U $1 -c $1 -p $(openssl passwd -crypt $2)

# copy authorized key
sudo cp -pr /home/vagrant/.ssh /home/$1
sudo cp -pr /home/vagrant/.ssh /root

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