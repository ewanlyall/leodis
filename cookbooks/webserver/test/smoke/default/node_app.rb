# # encoding: utf-8

# Inspec test for recipe webserver::node_app

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe 'webserver::node_app' do

  it 'installs the nodejs package' do
    expect(package "nodejs").to be_installed
  end

  it 'installs the express npm module' do
    expect(npm "express").to be_installed
  end

  it 'installs the express-handlebars npm module' do
    expect(npm "express-handlebars").to be_installed
  end
end
