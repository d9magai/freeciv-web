# coding: iso-8859-1
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Freeciv-web Vagrant Vagrantfile - play.freeciv.org
# 2014-02-17 - Andreas Røsdal
#
# Run 'vagrant up' in this directory, which will create a VirtualBox image,
# and run scripts/freeciv-web-bootstrap.sh to install Freeciv-web for you.
# Then point your browser to http://localhost/ on your host OS.
#

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Encoding.default_external = 'UTF-8'
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.provider "vmware_workstation" do |v|
    v.gui = true
    v.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "2", "--ioapic", "on"]
  end
end

