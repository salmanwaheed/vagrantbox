require_relative 'base.rb'

Vagrant.configure(2) do |vagrant_config|
  $machines.each do |value|
    vagrant_config.vm.define "#{value['user']}" do |conf|
      conf.vm.box = value['box'].to_s
      conf.vm.hostname = "#{value['private_ip']}".gsub('.', '-')
      conf.vm.box_check_update = false
      conf.vm.synced_folder ".", "/vagrant", disabled: true
      # conf.vm.usable_port_range = 8000..8999
      conf.vm.network "private_network", ip: value['private_ip'].to_s

      conf.vm.network :forwarded_port,
        guest: 22,
        host: value['port'].to_s,
        host_ip: "127.0.0.1",
        id: "ssh",
        auto_correct: true

      conf.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.cpus = value['cpus'].to_s
        vb.name = value['user'].to_s
        vb.memory = value['ram'].to_s
        vb.check_guest_additions = false
      end

      private_key_path = "#{Dir.pwd}/.ssh/id_rsa"
      public_key_path = "#{private_key_path}.pub"
      insecure_key = "~/.vagrant.d/insecure_private_key"

      if File.file?(public_key_path)
        conf.vm.provision :shell,
          path: "provision.sh",
          args: [
            value['user'].to_s,
            value['pass'].to_s,
            value['root_pass'].to_s,
            File.read(public_key_path),
            value['passwd_auth'].to_s
          ],
          privileged: true
      end

      if Vagrant.has_plugin?("vagrant-disksize")
        conf.disksize.size = value['disk_size'].to_s
      end

      if Vagrant.has_plugin?("vagrant-vbguest")
        conf.vbguest.auto_update = false
      end

      if $vagrantbox_conf_obj.include? 'SETUP_NEW_MACHINE' and $vagrantbox_conf_obj['SETUP_NEW_MACHINE'] == 'false'
        conf.ssh.username = value['user'].to_s
      end

      conf.ssh.forward_agent = true
      conf.ssh.insert_key = false
      conf.ssh.private_key_path = [insecure_key, private_key_path]
      # conf.vm.provision "file", source: public_key_path, destination: "$HOME/.ssh/authorized_keys"
    end
  end
end
