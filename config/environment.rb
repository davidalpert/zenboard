# Load the rails application
require File.expand_path('../application', __FILE__)

require 'bluecloth'

# Initialize the rails application
Zenboard::Application.initialize!

ActiveResource::Base.logger = ActiveRecord::Base.logger