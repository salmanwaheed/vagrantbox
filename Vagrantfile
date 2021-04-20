require 'yaml'

yaml_config_file = "#{Dir.pwd}/config.yml"

if File.exists?(yaml_config_file)
  yaml_config = YAML.load(File.read(yaml_config_file))

  Vagrant.configure(2) do |vagrant_config|
    yaml_config['machines'].each do |value|
      project_name = yaml_config['project_name'] || 'deletify'
      user         = value['user']               || 'admin'
      pass         = value['pass']               || 'admin'
      root_pass    = value['root_pass']          || 'root'
      port         = value['port']               || rand(65000 - 1024) + 1024
      passwd_auth  = value['passwd_auth']        || 'no'
      ip           = value['ip']                 || "192.168.%d.%d" % [rand(01...251), rand(10...251)]
      ram          = value['ram']                || 1024
      cpus         = value['cpus']               || 1
      disk_size    = value['disk_size']          || '10GB'
      box          = value['box']                || 'ubuntu/bionic64'

      vagrant_config.vm.define "#{user}" do |conf|
        conf.vm.box = box.to_s
        conf.vm.hostname = project_name
        conf.vm.box_check_update = false
        conf.vm.network "private_network", ip: ip
        conf.vm.synced_folder ".", "/vagrant", disabled: true

        conf.vm.network :forwarded_port,
          guest: 22,
          host: port,
          host_ip: "127.0.0.1",
          id: "ssh",
          auto_correct: true

        conf.vm.provider "virtualbox" do |vb|
          vb.gui = false
          vb.cpus = cpus
          vb.name = "#{user}@#{project_name}"
          vb.memory = ram
        end

        private_key_path = "#{Dir.pwd}/.ssh/id_rsa"
        public_key_path = "#{private_key_path}.pub"
        if File.file?(public_key_path)
          conf.vm.provision :shell,
            path: "provision.sh",
            args: [
              user.to_s,
              pass.to_s,
              root_pass.to_s,
              File.read(public_key_path),
              passwd_auth.to_s
            ],
            privileged: true
        end

        conf.disksize.size = disk_size

        if Vagrant.has_plugin?("vagrant-vbguest")
          conf.vbguest.auto_update = false
        end

        conf.ssh.forward_agent = true
        #conf.ssh.private_key_path = private_key_path
        #conf.ssh.username = user
      end
    end
  end
end
