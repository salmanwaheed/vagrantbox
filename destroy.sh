#!/bin/bash

if [ `which vagrant` ]; then

  if [ ! -f "$PWD/.ssh/id_rsa" ]; then
    echo "Nothing to destroy!!!!!"
    exit
  else
    vagrant destroy -f \
    && sleep 1 \
    && rm -rf "$PWD/.ssh" "$PWD/.vagrant" $PWD/*.log \
    && echo "Removed extra files." \
    && make clean_known_hosts_file \
    && sed -i '' "s/SETUP_NEW_MACHINE=false/SETUP_NEW_MACHINE=true/g" "$PWD/.vagrantbox.conf" \
    && echo "Vagrant machine(s) have been destroy."
  fi
else
  echo "Vagrant is not installed yet."
fi
