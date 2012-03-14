ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

ActiveSupport::Deprecation.silenced = true

require 'rails/test_help'
require "capybara/rails"
#require 'capybara/envjs'
#require 'johnson/tracemonkey'
#require 'envjs/runtime'

require 'sequences.rb'

module Test::Unit::Assertions
  def assert_false(object, message="")
    assert_equal(false, object, message)
  end
end

FILE_FOR_UPLOAD = "#{Rails.root}/test/upload.txt"
IMAGE_FILE_FOR_UPLOAD = "#{Rails.root}/test/test_image.png"

#Capybara.default_driver = :envjs
#Capybara.javascript_driver = :envjs
#Capybara.default_wait_time = 5

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module ActionController
  class IntegrationTest
    include Capybara
  end
end

def login_as(user)
  visit root_path
  fill_in 'Email', :with => user.email
  fill_in 'Password', :with => '123456'
  click_button "Sign in"
end