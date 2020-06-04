#!/bin/bash

set -e

install_package() {
  if ! bash-lib has_pkg "$@"; then
    brew cask install "$@"
  fi
}

USERNAME=$(bash-lib random abcd1234ABCD 8)
DOMAIN='local'
GUEST_PORT=22
HOST_PORT=$(bash-lib random 65535 4)
HOST_IP=127.0.0.1
PRIVATE_NETWORK="192.168.$(bash-lib random 123456789 2).$(bash-lib random 987654321 3)"
RAM=1024
CPUs=1
DISK_SIZE=20GB
INSTALL_DIR=~/ubuntu-${USERNAME}
VAGRANT_KEY=$INSTALL_DIR/.vagrant/machines/default/virtualbox/private_key

install_package vagrant virtualbox

if bash-lib has_pkg vagrant; then
  required_plugins=("vagrant-disksize" "vagrant-vbguest")
  existed_plugins=($(for plugin_name in $(vagrant plugin list | awk '{print $1}' | xargs); do echo "$plugin_name"; done))
  for index in ${!required_plugins[*]}; do
    if [[ ! "${existed_plugins[@]}" =~ "${required_plugins[$index]}" ]]; then
      vagrant plugin install ${required_plugins[$index]}
    fi
  done
fi

# remove know hosts
sed -i '' "/^\[$HOST_IP\]:$HOST_PORT/d" $HOME/.ssh/known_hosts && echo "Removed [$HOST_IP]:$HOST_PORT ECDSA key fingerprint from $HOME/.ssh/known_hosts."

# create dir where installtion need to be ran
[ -d "$INSTALL_DIR" ] && rm -rf "$INSTALL_DIR" && echo "old $INSTALL_DIR is removed!"
[ ! -d "$INSTALL_DIR" ] && mkdir -p "$INSTALL_DIR/.ssh" && echo "$INSTALL_DIR dir is created!"

# generate random key everytime
ssh-keygen -t rsa -b 4096 -C "$USERNAME@$DOMAIN" -f "$INSTALL_DIR/.ssh/id_rsa"

# store pub key
AUTHORIZED_KEYS=$(cat $INSTALL_DIR/.ssh/id_rsa.pub)

# create Vagrantfile
cat <<EOF > "$INSTALL_DIR/Vagrantfile"
Vagrant.configure("2") do |config|
    # box name
    config.vm.box = "ubuntu/xenial64"
    # machine name
    config.vm.define "$USERNAME"
    # hostname
    config.vm.hostname = "$DOMAIN"
    # disabled box update
    config.vm.box_check_update = false
    # SSH forwarded port
    config.vm.network :forwarded_port,
        guest: $GUEST_PORT,
        host: $HOST_PORT,
        host_ip: "$HOST_IP",
        id: "ssh",
        auto_correct: true
    # private network IP which will be availabled within the same network 
    config.vm.network "private_network", ip: "$PRIVATE_NETWORK"
    # disabled synced dir
    config.vm.synced_folder '.', '/vagrant', disabled: true
    # virtualbox settings
    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.cpus = $CPUs
        vb.name = "$USERNAME@$DOMAIN"
        vb.memory = "$RAM"
    end
    # config.vm.provision :shell, path: "bootstrap.sh"
    config.vm.provision "shell", inline: <<-SHELL
        # create user
        sudo useradd -m -s /bin/bash -U $USERNAME
        # create .ssh folder
        mkdir /home/$USERNAME/.ssh
        # give permission to only $USERNAME user
        chmod 700 /home/$USERNAME/.ssh
        # authorize id_rsa.pub key
        echo "$AUTHORIZED_KEYS" > /home/$USERNAME/.ssh/authorized_keys
        # change permission for authorized_keys
        chmod 600 /home/$USERNAME/.ssh/authorized_keys
        # change ownership to $USERNAME
        sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
        # no passwod required
        sudo echo \"%$USERNAME ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/$USERNAME
        sudo chmod 0440 /etc/sudoers.d/$USERNAME
    SHELL
    # disabled vbguest
    if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.auto_update = false
    end
    # increase size
    config.disksize.size = "$DISK_SIZE"
    # config.ssh.private_key_path = "$INSTALL_DIR/.ssh/id_rsa"
    # config.ssh.username = "$USERNAME"
end
EOF

# run vagrant
cd "$INSTALL_DIR" && vagrant up

# remove vagrant key
rm -rf $VAGRANT_KEY

# vagrant login must be failed
# ssh -i $VAGRANT_KEY vagrant@$HOST_IP -p $HOST_PORT # working

sleep 2

# $USERNAME must be login
# delete old users
ssh_login() {
    ssh -i $INSTALL_DIR/.ssh/id_rsa -t $USERNAME@$HOST_IP -p $HOST_PORT -o IdentitiesOnly=yes "$@"
}
ssh_login "sudo passwd $USERNAME"
ssh_login "sudo userdel -rf ubuntu" && echo "ubuntu has been removed!"
ssh_login "sudo userdel -rf vagrant" && echo "vagrant has been removed!"

# enable new user to login as ssh
sed -i '' 's/# config\.ssh\./config\.ssh\./' "$INSTALL_DIR/Vagrantfile"

# reload to update new configurations
cd "$INSTALL_DIR" && vagrant reload

# finally
echo """Important Information:
    Username: $USERNAME
    Guest Port: $GUEST_PORT
    Host Port: $HOST_PORT
    Host IP: $HOST_IP
    Private network IP: $PRIVATE_NETWORK
    RAM: $RAM
    CPUs: $CPUs
    Using Disk Space: $DISK_SIZE
    Installed directory: $INSTALL_DIR

    visit for more docs: https://www.vagrantup.com/docs/cli
    run 'cd $INSTALL_DIR' first then follow below steps
    to see config run 'vagrant ssh-config'
    to run the machine run 'vagrant up'
    to stop the machine 'vagrant halt'
    to completely remove virtual machine + vagrant machine run 'vagrant destroy'
"""
