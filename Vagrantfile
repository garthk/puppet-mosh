# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.host_name = "mosh"
  config.vm.share_folder "modules/mosh", "/tmp/vagrant-puppet/modules/mosh", ".", :create => true
  config.vm.network :hostonly, "192.168.31.44"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "tests"
    puppet.manifest_file = "vagrant.pp"
    puppet.options = ["--modulepath", "/tmp/vagrant-puppet/modules"]
  end
end
