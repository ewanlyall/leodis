#
# Cookbook:: webserver
# Recipe:: default
#

# Update the apt cache and keep it up to date
include_recipe "apt::default"

# create the www-data user group
group node['webserver']['run_group']

# create the www-data user and add it to the www-data group, ensure the user
# can't be used for interactive logins
user node['webserver']['run_user'] do
  group node['webserver']['run_group']
  system true
  shell '/bin/nologin'
end

# install the apache2 package and configure the leodis web service.
httpd_service node['webserver']['service_name'] do
  instance node['webserver']['service_name']
  contact 'webmasters@leodis.ac.uk'
  servername 'localhost'
  run_user 'www-data'
  run_group 'www-data'
  timeout '300'
  keepalive true
  keepalivetimeout '5'
  hostname_lookups 'off'
  listen_ports node['webserver']['listen_port']
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
httpd_config node['webserver']['service_name'] do
  config_name "#{node['webserver']['service_name']}-vhost"
  instance node['webserver']['service_name']
  source "#{node['webserver']['service_name']}-vhost.erb"
  notifies :restart, "httpd_service[#{node['webserver']['service_name']}]"
  action :create
end
