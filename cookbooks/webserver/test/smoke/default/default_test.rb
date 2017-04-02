# # encoding: utf-8

# Inspec test for recipe webserver::default

describe 'webserver::default' do

#  it 'enables the firewall and opens port 22 and 80' do
#    expect(firewall)
#  end

  it 'adds the www-data user' do
    expect(user "www-data").to exist
    expect(user("www-data").group).to eq "www-data"
    expect(user("www-data").shell).to eq "/bin/nologin"
  end

  it 'adds the www-data group' do
    expect(group "www-data").to exist
  end

  it 'installs the apache2 package' do
    expect(package "apache2").to be_installed
  end

  it 'creates the apache2 config file' do
    expect(file "/etc/apache2-leodis/apache2.conf").to exist
  end

  it 'creates the leodis-vhosts file' do
    expect(file "/etc/apache2-leodis/conf.d/leodis-vhost.conf").to exist
  end

  it 'starts and enables the apache2 service' do
    expect(service "apache2-leodis").to be_enabled
    expect(service "apache2-leodis").to be_running
  end

  it 'listens on port 80' do
    expect(port 80).to be_listening
    expect(port(80).processes).to eq ["apache2"]
  end

  it 'returns the home page' do
    expect(http("http://localhost:8080").status).to eq 200
# look for some text on the homepage
  end
end
