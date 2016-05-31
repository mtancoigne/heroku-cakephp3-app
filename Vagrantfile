# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'minimal/trusty64'

  config.vm.network :private_network, ip: '192.168.56.101'
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.network :forwarded_port, guest: 5000, host: 5000, auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '512']
  end

  config.vm.synced_folder '.', '/vagrant',
                          owner: 'www-data',
                          group: 'www-data',
                          mount_options: ['dmode=775', 'fmode=774']

  # https://github.com/fgrehm/vagrant-cachier
  if Vagrant.has_plugin?('vagrant-cachier')
    machine_id.cache.scope = :box
  end

  # Add the tty fix as mentioned in issue 1673 on vagrant repo
  # To avoid 'stdin is not a tty' messages
  # vagrant provisioning in shell runs bash -l
  config.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision :shell, path: './vagrant/provision.sh'
end
