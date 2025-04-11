ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def create_hospitable_message_webhook
      {
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "data": {
          "platform": "airbnb",
          "platform_id": 0,
          "conversation_id": "becd1474-ccd1-40bf-9ce8-04456bfa338d",
          "reservation_id": "becd1474-ccd1-40bf-9ce8-04456bfa338d",
          "content_type": "text/plain",
          "body": "Hello, there.",
          "attachments": [
            {
              "type": "image",
              "url": "The image location URL"
            }
          ],
          "sender_type": "host",
          "sender_role": "host|co-host|teammate|null",
          "sender": {
            "first_name": "Jane",
            "full_name": "Jane Doe",
            "locale": "en",
            "picture_url": "https://a0.muscache.com/im/pictures/user/f391da23-c76e-4728-a9f2-25cc139a13cc.jpg?aki_policy=profile_x_medium",
            "thumbnail_url": "https://a0.muscache.com/im/pictures/user/f391da23-c76e-4728-a9f2-25cc139a13cc.jpg?aki_policy=profile_x_medium",
            "location": null
          },
          "user": {
            "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
            "email": "user@example.com",
            "name": "string"
          },
          "created_at": "2019-07-29T19:01:14Z"
        },
        "action": "message.created",
        "created": "2024-10-08T07:03:34Z",
        "version": "v2"
      }
    end
  end
end
