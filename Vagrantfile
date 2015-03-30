# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.box_url = 'https://atlas.hashicorp.com/ubuntu/boxes/trusty64'
  config.vm.network :private_network, ip: '192.168.33.10'
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '512']
  end
  config.vm.synced_folder '.', '/vagrant',
                          type: 'nfs',
                          mount_options: ['rw', 'vers=3', 'tcp', 'nolock']

  # https://github.com/fgrehm/vagrant-cachier
  if Vagrant.has_plugin? 'vagrant-cachier'
    config.cache.scope = 'box'
    config.cache.synced_folder_opts = {
      type: 'nfs',
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  config.vm.provision :shell, path: './vagrant/provision.sh'
end
