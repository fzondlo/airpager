require "sidekiq/web"

Sidekiq.strict_args!(false)

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1"),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1"),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

if Rails.env.production?
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest("airpager")) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest("aircontrol"))
  end
end

# Force locale to English for Sidekiq Web
class SidekiqLocaleMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    I18n.locale = :en
    @app.call(env)
  end
end

Sidekiq::Web.use SidekiqLocaleMiddleware
