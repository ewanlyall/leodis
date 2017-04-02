#
# Cookbook:: webserver
# Recipe:: default
#

# Update the apt cache and keep it up to date
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

# install the apache2 package and configure the leodis web service.
httpd_service 'leodis' do
  instance 'leodis'
  contact 'webmasters@leodis.ac.uk'
  servername 'localhost'
  run_user 'www-data'
  run_group 'www-data'
  timeout '300'
  keepalive true
  keepalivetimeout '5'
  hostname_lookups 'off'
  listen_ports ['80']
  action [:create, :start]
end

# install the proxy_http and proxy apache modules required for the proxypass
# vhost configuration
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

# create the leodis vhost configuration and restart apache.
# we could generalise the template further and use attributes.
httpd_config 'leodis' do
  config_name 'leodis-vhost'
  instance 'leodis'
  source 'leodis-vhost.erb'
  notifies :restart, 'httpd_service[leodis]'
  action :create
end
