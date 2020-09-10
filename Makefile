destroy:
	@vagrant destroy -f
	@rm -rf .ssh .vagrant *.log
	@make unset_config
	@echo "uninstalled vagrant machine"

setup: gen_ssh_key vagrant_up set_config remove_old_private_key
	@vagrant ssh-config
	@echo "Installed vagrant machine :)"
	@echo ""
	@echo "visit for more docs: https://www.vagrantup.com/docs/cli"
	@echo ""
	@echo "login via 'vagrant ssh'"
	@echo "start machine via 'vagrant up'"
	@echo "stop machine via 'vagrant halt'"
	@echo "remove machine 'vagrant destroy'"

gen_ssh_key:
	@mkdir -p "${PWD}/.ssh"
	@ssh-keygen -t rsa -b 4096 -f "${PWD}/.ssh/id_rsa"  -q -P "" <<<y 2>&1 >/dev/null
	@echo "ssh keys are generated"

vagrant_up:
	@vagrant up --provision
	@echo "virtual machine is ready"

unset_config:
	@sed -i '' -e 's/    box\.ssh\.username/    #box\.ssh\.username/' Vagrantfile
	@sed -i '' -e 's/    box\.ssh\.private_key_path/    #box\.ssh\.private_key_path/' Vagrantfile
	@echo "configuration has unset"

set_config:
	@sed -i '' -e 's/    #box/    box/' Vagrantfile
	@echo "configuration has updated"

remove_old_private_key:
	@rm -rf "${PWD}/.vagrant/machines/*/virtualbox/private_key"
	@echo "removed unused data"

