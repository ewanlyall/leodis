#
# Cookbook:: webserver
# Recipe:: default
#

# Update the apt cache
include_recipe "apt::default"

# create the www-data user group
group 'www-data'

# create the www-data user and add it to the www-data group, ensure the user
# can't be used for interactive logins
user 'www-data' do
  group 'www-data'
  system true
  shell '/bin/nologin'
end

# install the apache2 package
httpd_service 'leodis' do
  instance 'leodis'
  contact 'webmasters@leodis.ac.uk'
  servername 'localhost'
  timeout '300'
  keepalive true
  keepalivetimeout '5'
  hostname_lookups 'off'
  listen_ports ['80']
  action [:create, :start]
end

httpd_module 'proxy_http' do
  instance 'leodis'
  module_name 'proxy_http'
  action :create
end

httpd_module 'proxy' do
  instance 'leodis'
  module_name 'proxy'
  action :create
end

httpd_config 'leodis' do
  config_name 'leodis-vhost'
  instance 'leodis'
  source 'leodis-vhost.erb'
  notifies :restart, 'httpd_service[leodis]'
  action :create
end
