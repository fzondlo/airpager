ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "sidekiq/testing"
require "mocha/minitest"

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

    def create_incident(overrides = {})
      Incident.create!({
        kind: "pending_reply"
      }.merge(overrides))
    end

    def create_message(overrides = {})
      Message.create!({
        conversation_id: "conv-test-123",
        sender_full_name: "jeremie ges",
        content: "Hello! I'm planning a trip to the area and would love to stay at your flat."
      }.merge(overrides))
    end

    def create_auto_reply(overrides = {})
      AutoReply.create!({
        trigger: "What is the Wi-Fi code?",
        reply: "The Wi-Fi code is welcomehome"
      }.merge(overrides))
    end

    def create_property(overrides = {})
      Property.create!({
        name: "Murano 901",
        clickup_custom_field_id: "cf-123"
      }.merge(overrides))
    end

    # Add more helper methods to be used by all tests here...
  end
end
