#!/bin/bash

if [ `which vagrant` ]; then
  [ ! -d "${PWD}/.ssh" ] \
    && mkdir -p "${PWD}/.ssh" \
    && ssh-keygen -t rsa -b 4096 -C "" -f "${PWD}/.ssh/id_rsa" -q -P "" <<<y 2>&1 >/dev/null \
    && echo "Private and Public keys are generated." \
    || echo "Using existing Private and Public keys."

  make new_machine_true

  vagrant up \
    && sleep 1 \
    && make new_machine_false \
    && echo "virtual machine is ready"
else
  echo "Vagrant is not installed yet."
fi
