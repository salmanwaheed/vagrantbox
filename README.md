# vagrantbox

We must be protected our data while using 3rd party vagrant boxes, ISOs, VDIs.

[Linux Cheatsheets](https://deletify.app/cheatsheets/linux/)
[Vagrant Cheatsheets](https://deletify.app/cheatsheets/vagrant/)

## Install
_Virtualbox or any relavent tool is required to run Vagrant._

**Linux (Debian, Ubuntu, Mint)**
```bash
$ apt-get install virtualbox vagrant
```

**MacOSx** _(don't forget to install [Homebrew](https://brew.sh/) if you don't have one)_
```bash
$ brew cask install virtualbox vagrant
```

**Windoes** Download from the following links
- [VirtualBox](https://download.virtualbox.org/virtualbox/6.1.18/VirtualBox-6.1.18-142142-Win.exe)
- [Vagrant 64-bit](https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.msi) OR
- [Vagrant 32-bit](https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_i686.msi)

## Prerequisites

- Create directory `mkdir my-vagrant & cd my-vagrant`
- Download Repo
- Install Plugins
```sh
$ vagrant plugin install vagrant-disksize vagrant-vbguest
```
- first/one time installation `make setup`
- use `make destroy` instead of `vagrant destroy -f`
- if you are in current directory where vagrantbox has setup
  * login via ssh `vagrant ssh <USERNAME>`
  * stop machine `vagrant halt <USERNAME>`
  * start machine `vagrant up <USERNAME>`
* otherwise run `vagrant global-status` get the ID and then
  * login `vagrant ssh <ID>`
  * start machine `vagrant up <ID>`
  * stop machine `vagrant halt <ID>`

[Vagrant Cheatsheets](https://deletify.app/cheatsheets/vagrant/)

## Tips to learn advance

#### run any command without going inside the machine via

```ssh -p <PORT> -i <ID_RSA_PATH> <USER@DOMAIN> 'ANY-LINUX-COMMAND'```

#### transfer any data without going inside the machine via

```sudo scp -P <PORT> -i <ID_RSA_PATH> </local/path> <USER@DOMAIN>:/remote/path```

#### generate ssh key via

```ssh-keygen -t rsa -b 4096 -C "your@email.com" -f /path/to/key```

#### create public key from private key via

```ssh-keygen -y -f .ssh/id_rsa > .ssh/id_rsa.pub```
