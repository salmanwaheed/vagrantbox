env_boxes = {
  :staging => {
    user: "stg-user",
    pass: "stg123@",
    root_pass: "StgRoot123@",
    port: 2040,
    ip: "192.168.66.16",
    ram: 1024,
    cpus: 1,
    disk_size: "10GB",
    box: "ubuntu/bionic64",
  },
  :live => {
    user: "live-user",
    pass: "live123@",
    root_pass: "LiveRoot123@",
    port: 2050,
    ip: "192.168.55.66",
    ram: 1024,
    cpus: 1,
    disk_size: "10GB",
    box: "ubuntu/bionic64",
  }
}

Vagrant.configure(2) do |config|
  env_boxes.each do |env_as_key, value|
    config.vm.define "#{value[:user]}" do |box|
      box.vm.box = value[:box]
      box.vm.hostname = env_as_key
      box.vm.box_check_update = false
      box.vm.network "private_network", ip: value[:ip]
      box.vm.synced_folder ".", "/vagrant", disabled: true

      box.vm.network :forwarded_port, guest: 22,
          host: value[:port], host_ip: "127.0.0.1", id: "ssh", auto_correct: true

      box.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.cpus = value[:cpus]
        vb.name = "#{value[:user]}@#{env_as_key}"
        vb.memory = value[:ram]
      end

      if File.exist?(".ssh/id_rsa.pub")
        box.vm.provision :shell, path: "provision.sh",
            args: [value[:user], value[:pass], value[:root_pass], File.read('.ssh/id_rsa.pub')],
            privileged: true
      end

      box.disksize.size = value[:disk_size]

      if Vagrant.has_plugin?("vagrant-vbguest")
        box.vbguest.auto_update = false
      end

      box.ssh.forward_agent = true
      #box.ssh.private_key_path = ".ssh/id_rsa"
      #box.ssh.username = value[:user]
    end
  end
end
