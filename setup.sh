#!/bin/bash

if [ `which vagrant` ]; then
  [ ! -d "${PWD}/.ssh" ] \
    && mkdir -p "${PWD}/.ssh" \
    && ssh-keygen -t rsa -b 4096 -C "" -f "${PWD}/.ssh/id_rsa" -q -P "" <<<y 2>&1 >/dev/null \
    && echo "Private and Public keys are generated." \
    || echo "Using existing Private and Public keys."

  sed -i '' "s/SETUP_NEW_MACHINE=false/SETUP_NEW_MACHINE=true/g" "$PWD/.vagrantbox.conf"

  vagrant up \
    && echo "virtual machine is ready" \
    && sleep 1 \
    && sed -i '' 's/SETUP_NEW_MACHINE=true/SETUP_NEW_MACHINE=false/g' "$PWD/.vagrantbox.conf"
else
  echo "Vagrant is not installed yet."
fi
