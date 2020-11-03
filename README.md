# devops-box

We must be protected our data while using 3rd party vagrant boxes, ISOs, VDIs.

**Install**

* Prerequisites
  * install software [vagrant](https://www.vagrantup.com/downloads.html) and [virtualbox](https://www.virtualbox.org/wiki/Downloads)
  * install plugins `vagrant plugin install vagrant-disksize vagrant-vbguest`
* clone repo `git clone https://github.com/salmanwaheed/devops-box.git`
* go into the directory `cd devops-box`
* first/one time installation `make setup`
* use `make destroy` instead of `vagrant destroy -f`
* if you are in current directory where vagrantbox has setup
  * login via ssh `vagrant ssh <USERNAME>`
  * stop machine `vagrant halt <USERNAME>`
  * start machine `vagrant up <USERNAME>`
* otherwise run `vagrant global-status` get the ID and then
  * login `vagrant ssh <ID>`
  * start machine `vagrant up <ID>`
  * stop machine `vagrant halt <ID>`

## Tips to learn advance

#### run any command without going inside the machine via

```ssh -p <PORT> -i <ID_RSA_PATH> <USER@DOMAIN> 'ANY-LINUX-COMMAND'```

#### transfer any data without going inside the machine via

```sudo scp -P <PORT> -i <ID_RSA_PATH> </local/path> <USER@DOMAIN>:/remote/path```

#### generate ssh key via

```ssh-keygen -t rsa -b 4096 -C "your@email.com" -f /path/to/key```

#### create public key from private key via

```ssh-keygen -y -f .ssh/id_rsa > .ssh/id_rsa.pub```
