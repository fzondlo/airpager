ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'sidekiq/testing'

Sidekiq::Testing.fake!

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # fixtures :all
    setup do
      Sidekiq::Worker.clear_all
    end

    # Add more helper methods to be used by all tests here...
  end
end

