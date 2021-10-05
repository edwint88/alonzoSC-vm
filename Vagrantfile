# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# in case you need more vms just increase this number
NUM_NODE = 1

IP_NW = "192.168.5."
NODE_IP_START = 10
VAGRANT_BOX = "ubuntu/focal64"
VM_USER = 'vagrant'
NODE_NAME = 'alonzo-node'

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = VAGRANT_BOX
  config.vm.box_check_update = false

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../dev", "/home/" + VM_USER + "/dev"

  # Provision Nodes
  (1..NUM_NODE).each do |i|
      config.vm.define "#{NODE_NAME}-#{i}" do |node|
        # Name shown in the GUI
        node.vm.provider "virtualbox" do |vb|
            vb.name = "#{NODE_NAME}-#{i}"
            # Setup the VM RAM 8GB
            vb.memory = 8192
            # alternative: virtualbox.customize ["modifyvm", :id, "--memory", 8192]
            # Setup the VM CPU
            vb.cpus = 4
        end
        node.vm.hostname = "#{NODE_NAME}-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
        node.vm.network "forwarded_port", guest: 22, host: "#{2710 + i}"
        node.vm.network "forwarded_port", guest: 8009, host: "#{8008 + i}"
        node.vm.network "forwarded_port", guest: 3001, host: "#{3000 + i}"
        node.vm.network "forwarded_port", guest: 6000, host: "#{5999 + i}"
        node.vm.network "forwarded_port", guest: 1337, host: "#{1336 + i}"

        # if you are using multi nodes you have to change this file to add the other nodes in order to see eachother
        node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
          s.args = ["enp0s8"]
        end

        config.vm.provision "shell", inline: <<-SHELL
          apt-get update
          apt-get upgrade -y
          apt-get autoremove -y
          apt-get install git tmux curl expect jq bc make automake rsync htop curl build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev g++ wget libncursesw5 libtool autoconf libncurses-dev libtinfo5 -y
        SHELL

        # steup dns
        node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"

        # prepare vim
        config.vm.provision "file", :source => "ubuntu/vim/vimrc", :destination => ".vimrc"
        config.vm.provision "file", :source => "ubuntu/vim/coc-settings.json", :destination => ".vim/coc-settings.json"

        # prepare nix
        config.vm.provision "file", :source => "ubuntu/nix/nix.conf", :destination => "/etc/nix/nix.conf"
        
        # install nix
        node.vm.provision "install-nix", type: "shell", :path => "ubuntu/install-nix.sh", privileged: false
        
        # if you need docker activate this line
        #node.vm.provision "install-docker", type: "shell", :path => "ubuntu/install-docker.sh"
        
        # prepare plutus
        node.vm.provision "prepare-plutus", type: "shell", :path => "ubuntu/prepare-plutus.sh", privileged: false do |s|
          s.args = [VM_USER]
        end

        # prepare cardano-node :: cardano-cli 
        node.vm.provision "install-cardano-deps", type: "shell", :path => "ubuntu/cardano-node/cardano-deps.sh", privileged: false

        config.vm.provision "file", :source => "ubuntu/cardano-node/testnet-topology.json", :destination => "cardano-my-node/testnet-topology.json"
        config.vm.provision "file", :source => "ubuntu/cardano-node/startRelayNode1.sh", :destination => "cardano-my-node/startRelayNode1.sh"
        config.vm.provision "file", :source => "ubuntu/cardano-node/relay-topology_pull.sh", :destination => "cardano-my-node/relay-topology_pull.sh"
        config.vm.provision "file", :source => "ubuntu/cardano-node/cardano-node.service", :destination => "cardano-my-node/cardano-node.service"

        node.vm.provision "install-cardano-last-steps", type: "shell", :path => "ubuntu/cardano-node/cardano-last-steps.sh", privileged: false
      end
  end
end
