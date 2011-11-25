# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Voteunit::Application.initialize!

FACEBOOK_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/facebook.yml")[Rails.env].symbolize_keys
