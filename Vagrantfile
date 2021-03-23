require 'yaml'

if File.read("#{Dir.pwd}/config.yml")
  read_config = YAML.load(File.read("#{Dir.pwd}/config.yml"))
  Vagrant.configure(2) do |config|
    read_config['machines'].each do |key, value|
      config.vm.define "#{value['user']}" do |box|
        box.vm.box = value['box'].to_s
        box.vm.hostname = read_config['project_name']
        box.vm.box_check_update = false
        box.vm.network "private_network", ip: value['ip']
        box.vm.synced_folder ".", "/vagrant", disabled: true

        box.vm.network :forwarded_port,
          guest: 22,
          host: value['port'],
          host_ip: "127.0.0.1",
          id: "ssh",
          auto_correct: true

        box.vm.provider "virtualbox" do |vb|
          vb.gui = false
          vb.cpus = value['cpus']
          vb.name = "#{value['user']}@#{read_config['project_name']}"
          vb.memory = value['ram']
        end

        if File.file?("#{Dir.pwd}/.ssh/id_rsa.pub")
          box.vm.provision :shell,
            path: "provision.sh",
            args: [
              value['user'].to_s,
              value['pass'].to_s,
              value['root_pass'].to_s,
              File.read("#{Dir.pwd}/.ssh/id_rsa.pub"),
              value['passwd_auth'].to_s
            ],
            privileged: true
        end

        box.disksize.size = value['disk_size']

        if Vagrant.has_plugin?("vagrant-vbguest")
          box.vbguest.auto_update = false
        end

        box.ssh.forward_agent = true
        #box.ssh.private_key_path = "#{Dir.pwd}/.ssh/id_rsa"
        #box.ssh.username = value['user']
      end
    end
  end
end
