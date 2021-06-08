require 'yaml'

yaml_config_file = "#{Dir.pwd}/config.yml"

if !File.exists?(yaml_config_file)
  puts "The #{yaml_config_file} file is missing"
  abort
end

yaml_config = YAML.load_file(yaml_config_file)
machines = yaml_config['machines']
project_name = yaml_config['project_name'] || 'deletify'

if !project_name || project_name.empty?
  puts "No project_name defined in #{yaml_config_file}"
  abort
end

if !machines || machines.empty?
  puts "No machines defined in #{yaml_config_file}"
  abort
end

vagrantbox_conf_file = "#{Dir.pwd}/.vagrantbox.conf"
if !File.exists?(vagrantbox_conf_file)
  puts "The #{vagrantbox_conf_file} file is missing"
  abort
end

vagrantbox_conf = {}
File.readlines(vagrantbox_conf_file).each do |line|
  item = line.split('=')
  if item.length() == 2
    vagrantbox_conf[item[0]] = "#{item[1]}".gsub("\n", '')
  end
end

Vagrant.configure(2) do |vagrant_config|
  machines.each do |value|

    required_fields = ['user', 'pass', 'port', 'private_ip']
    required_fields.each do |item|
      if not value.include? item
        puts "'#{item}' is required. Please add it to 'config.yml' file"
        abort
      end

      if value[item].nil?
        puts "'#{item}' must have a 'value'. Please add it to 'config.yml' file"
        abort
      end
    end

    user         = value['user']
    pass         = value['pass']
    port         = value['port']
    private_ip   = value['private_ip']
    root_pass    = value['root_pass']          || 'root'
    passwd_auth  = value['passwd_auth']        || 'no'
    ram          = value['ram']                || 1024
    cpus         = value['cpus']               || 1
    disk_size    = value['disk_size']          || '10GB'
    box          = value['box']                || 'ubuntu/bionic64'

    vagrant_config.vm.define "#{user}" do |conf|
      conf.vm.box = box.to_s
      conf.vm.hostname = "#{project_name}-#{private_ip}".gsub('.', '-')
      conf.vm.box_check_update = false
      conf.vm.synced_folder ".", "/vagrant", disabled: true
      # conf.vm.usable_port_range = 8000..8999
      conf.vm.network "private_network", ip: private_ip

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
        vb.check_guest_additions = false
      end

      private_key_path = "#{Dir.pwd}/.ssh/id_rsa"
      public_key_path = "#{private_key_path}.pub"
      insecure_key = "~/.vagrant.d/insecure_private_key"

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

      if Vagrant.has_plugin?("vagrant-disksize")
        conf.disksize.size = disk_size
      end

      if Vagrant.has_plugin?("vagrant-vbguest")
        conf.vbguest.auto_update = false
      end

      if vagrantbox_conf.include? 'SETUP_NEW_MACHINE' and vagrantbox_conf['SETUP_NEW_MACHINE'] == 'false'
        conf.ssh.username = user
      end

      conf.ssh.forward_agent = true
      conf.ssh.insert_key = false
      conf.ssh.private_key_path = [insecure_key, private_key_path]
      # conf.vm.provision "file", source: public_key_path, destination: "$HOME/.ssh/authorized_keys"
    end
  end
end
