#
# Cookbook:: webserver
# Recipe:: node_app
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe "nodejs::nodejs"

nodejs_npm "express"
nodejs_npm "express-handlebars"

# At this point, we would pull the nodejs application code from source control,
# artifactory or wherever it is stored. It shouldn't be stored in a chef repo.
