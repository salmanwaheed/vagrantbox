VAGRANT_VERSION = 2
VAGRANT_USERNAME = "thor"
VAGRANT_PASSWORD = "thor123@"
VAGRANT_ROOT_PASSWORD = "Root123@"
VAGRANT_DOMAIN = "marvel"
VAGRANT_GUEST_PORT = 22
VAGRANT_HOST_PORT = 2040
VAGRANT_HOST_IP = "127.0.0.1"
VAGRANT_RAM = 1024
VAGRANT_CPUs = 1
VAGRANT_DISK_SIZE = "10GB"
VAGRANT_PRIVATE_NETWORK = "192.168.55.66"
VAGRANT_BOX = "ubuntu/xenial64"

Vagrant.configure(VAGRANT_VERSION) do |config|
    config.vm.box = VAGRANT_BOX
    config.vm.define VAGRANT_USERNAME
    config.vm.hostname = VAGRANT_DOMAIN
    config.vm.box_check_update = false
    config.vm.network "private_network", ip: VAGRANT_PRIVATE_NETWORK
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.network :forwarded_port, guest: VAGRANT_GUEST_PORT,
        host: VAGRANT_HOST_PORT, host_ip: VAGRANT_HOST_IP, id: "ssh", auto_correct: true

    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.cpus = VAGRANT_CPUs
        vb.name = "#{VAGRANT_USERNAME}@#{VAGRANT_DOMAIN}"
        vb.memory = VAGRANT_RAM
    end

    if File.exist?(".ssh/id_rsa.pub")
      config.vm.provision :shell, :path => "provision.sh",
          :args => [VAGRANT_USERNAME, VAGRANT_PASSWORD, VAGRANT_ROOT_PASSWORD, File.read('.ssh/id_rsa.pub')],
          privileged: true
    end

    config.disksize.size = VAGRANT_DISK_SIZE

    if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.auto_update = false
    end

    config.ssh.forward_agent = true
    #config.ssh.private_key_path = ".ssh/id_rsa"
    #config.ssh.username = VAGRANT_USERNAME
end
