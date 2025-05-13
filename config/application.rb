require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Airpager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.time_zone = "America/Bogota"
    config.active_record.default_timezone = :utc

    # config.after_initialize do
    #   if Rails.env.production? || Rails.env.staging?
    #     # add prod url
    #   end
    #
    #   if Rails.env.development?
    #     local_ngrok_url = "https://cf77-186-121-47-138.ngrok-free.app/wappi_webhooks"
    #     Waapi.gateway.rb.register_webhook(local_ngrok_url)
    #     puts "WaAPI registered w/ webhook #{local_ngrok_url}"
    #   end
    # end

  end
end
