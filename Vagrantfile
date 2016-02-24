# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

begin
  boxconfig = YAML.load_file('config.yml')
rescue Errno::ENOENT
  abort "No config.yml found. Copy config.yml.example to get started."
end

if boxconfig['type']
  unless File.file?(boxconfig['type'] + '.sh')
    abort "the type " + boxconfig['type'] + " does not exist."
  end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Set the hostname so you can destinguish between your different projects
  config.vm.hostname = boxconfig['project']

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: boxconfig['ip']
  if boxconfig['pubip']
    config.vm.network "public_network", ip: boxconfig['pubip']
  end

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  if (RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/)
    config.vm.synced_folder boxconfig['path'], "/var/www/website", id: "website", type: "nfs", mount_options: ["rw","vers=3","udp","actimeo=2"]
  else
    config.vm.synced_folder boxconfig['path'], "/var/www/website", id: "website"
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    vb.name = "mage2-" + boxconfig['project']
    vb.memory = boxconfig['memory']
    vb.cpus = boxconfig['cpus']
    if RUBY_PLATFORM =~ /linux/
      vb.customize ["modifyvm", :id, "--paravirtprovider", "kvm"]
    end
  end

  # stdin: is not a tty
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.ssh.forward_agent = true

  config.vm.provision :shell, :path => boxconfig['type'] + '.sh'
end
