#!/bin/bash

set -e

if command -v vagrant >/dev/null 2>&1; then 
    required_plugins=("vagrant-disksize" "vagrant-vbguest")
    existed_plugins=($(for plugin_name in $(vagrant plugin list | awk '{print $1}' | xargs); do echo "$plugin_name"; done))

    for index in ${!required_plugins[*]}; do
        if [[ ! "${existed_plugins[@]}" =~ "${required_plugins[$index]}" ]]; then
            vagrant plugin install ${required_plugins[$index]}
        fi
    done

    echo "vagrant is already installed"
else
    echo 'ERROR: vagrant is required'
fi

command -v virtualbox >/dev/null 2>&1 && echo "virtualbox is already installed" || echo 'ERROR: virtualbox is required'

if command -v vagrant virtualbox >/dev/null 2>&1; then
    sed -i '' "/^\[localhost\]:2040/d" $HOME/.ssh/known_hosts && echo "Removed [localhost]:2040 ECDSA key fingerprint from $HOME/.ssh/known_hosts."

    mkdir -p $PWD/.ssh
    ssh-keygen -t rsa -b 4096 -f $PWD/.ssh/id_rsa  -q -P ""

    copy_ssh_to() {
        sudo scp -o IdentitiesOnly=yes -P 2040 -i $PWD/.vagrant/machines/thor/virtualbox/private_key -r $PWD/.ssh root@localhost:$1
    }

    copy_ssh_to /root
    copy_ssh_to /home/thor

    # generator pub key from private key
    # ssh-keygen -y -f $PWD/.vagrant/machines/thor/virtualbox/private_key > $PWD/.vagrant/machines/thor/virtualbox/private_key.pub

    echo -n "Proceed? [y/n]: "
    read ans
    echo $ans
fi
