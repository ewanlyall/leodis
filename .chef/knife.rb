current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "admin"
client_key               "#{current_dir}/../secrets/admin.pem"
chef_server_url          "https://chef-server.leodis.ac.uk/organizations/leodis"
cookbook_path            ["#{current_dir}/../cookbooks"]
