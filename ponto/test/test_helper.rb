ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  fixtures :all
end

require 'capybara/rails'
require 'support/integration'
require 'warden/test/helpers'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Support::Integration
  include Warden::Test::Helpers

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver

    Warden.test_reset!
  end
end
