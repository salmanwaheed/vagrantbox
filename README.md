# Vagrant Secure Machine

We must be protected our data while using 3rd party vagrant boxes, ISOs, VDIs.

_Compatible with MacOS only_

**Install**

* You must install these packages first
  * https://github.com/salmanwaheed/bash-lib
  * https://brew.sh/

```bash
# after installed bash-lib & homebrew (for mac) you can run this command
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/salmanwaheed/vagrant-secure-machine/master/install.sh)"
```

## TODO
* [x] random username
* [x] random ssh host port
* [ ] random ssh guest port
* [x] random machine names
* [x] random ssh key every installations
* [x] remove all other users except random generated
* [x] user must set the password during installtions
