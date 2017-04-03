#
# Cookbook:: webserver
# Recipe:: node_app
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Install the nodejs package
include_recipe "nodejs::nodejs"

# Install some required npm modules
nodejs_npm "express"
nodejs_npm "express-handlebars"

# At this point, we would pull the nodejs application code from source control,
# artifactory or wherever it is stored. It shouldn't be stored in a chef repo.
