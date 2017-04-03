# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

CHEF_SERVER_SCRIPT = <<EOF.freeze
apt-get update
apt-get -y install curl

# ensure the time is up to date
echo "Synchronizing time..."
apt-get -y install ntp
service ntp stop
ntpdate -s time.nist.gov
service ntp start

# download the Chef server package
echo "Downloading the Chef server package..."
if [ ! -f /downloads/chef-server-core_12.11.1_amd64.deb ]; then
  wget -nv -P /downloads https://packages.chef.io/files/stable/chef-server/12.14.0/ubuntu/16.04/chef-server-core_12.14.0-1_amd64.deb
fi

# install the package
echo "Installing Chef server..."
sudo dpkg -i /downloads/chef-server-core_12.14.0-1_amd64.deb

# reconfigure and restart services
echo "Reconfiguring Chef server..."
sudo chef-server-ctl reconfigure
echo "Restarting Chef server..."
sudo chef-server-ctl restart

# wait for services to be fully available
echo "Waiting for services..."
until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

# create admin user
echo "Creating a user and organization..."
sudo chef-server-ctl user-create admin Ewan Lyall ewan.lyall@gmail.com insecurepassword --filename admin.pem
sudo chef-server-ctl org-create leodis "The University of Leodis" --association_user admin --filename leodis-validator.pem

# copy admin RSA private key to share
echo "Copying admin key to /vagrant/secrets..."
mkdir -p /vagrant/secrets
cp -f /home/vagrant/admin.pem /vagrant/secrets

echo "Your Chef server is ready!"
EOF

NODE_SCRIPT = <<EOF.freeze
echo "Preparing node..."

# ensure the time is up to date
apt-get update
apt-get -y install ntp
service ntp stop
ntpdate -s time.nist.gov
service ntp start

echo "10.1.1.33 chef-server.leodis.ac.uk" | tee -a /etc/hosts
EOF

def set_hostname(server)
  server.vm.provision 'shell', inline: "hostname #{server.vm.hostname}"
end

Vagrant.configure(2) do |config|
  config.vm.define 'chef-server' do |cs|
    cs.vm.box = 'ubuntu/trusty64'
    cs.vm.hostname = 'chef-server.leodis.ac.uk'
    cs.vm.network 'private_network', ip: '10.1.1.33'
    cs.vm.provision 'shell', inline: CHEF_SERVER_SCRIPT.dup
    set_hostname(cs)

    cs.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define 'web-server' do |ws|
    ws.vm.box = 'ubuntu/precise64'
    ws.vm.hostname = 'web-server.leodis.ac.uk'
    ws.vm.network 'private_network', ip: '10.1.1.34'
    ws.vm.provision :shell, inline: NODE_SCRIPT.dup
    set_hostname(ws)
  end
end
