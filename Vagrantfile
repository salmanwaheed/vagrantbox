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
VAGRANT_BOX = "ubuntu/bionic64"

Vagrant.configure(VAGRANT_VERSION) do |config|
  config.vm.define "#{VAGRANT_DOMAIN}" do |box|
    box.vm.box = VAGRANT_BOX
    box.vm.hostname = VAGRANT_DOMAIN
    box.vm.box_check_update = false
    box.vm.network "private_network", ip: VAGRANT_PRIVATE_NETWORK
    box.vm.synced_folder ".", "/vagrant", disabled: true

    box.vm.network :forwarded_port, guest: VAGRANT_GUEST_PORT,
        host: VAGRANT_HOST_PORT, host_ip: VAGRANT_HOST_IP, id: "ssh", auto_correct: true

    box.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.cpus = VAGRANT_CPUs
        vb.name = "#{VAGRANT_USERNAME}@#{VAGRANT_DOMAIN}"
        vb.memory = VAGRANT_RAM
    end

    if File.exist?(".ssh/id_rsa.pub")
      box.vm.provision :shell, :path => "provision.sh",
          :args => [VAGRANT_USERNAME, VAGRANT_PASSWORD, VAGRANT_ROOT_PASSWORD, File.read('.ssh/id_rsa.pub')],
          privileged: true
    end

    box.disksize.size = VAGRANT_DISK_SIZE

    if Vagrant.has_plugin?("vagrant-vbguest")
        box.vbguest.auto_update = false
    end

    box.ssh.forward_agent = true
    #box.ssh.private_key_path = ".ssh/id_rsa"
    #box.ssh.username = VAGRANT_USERNAME
  end
end
