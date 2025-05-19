Datadog.configure do |c|
  # Name your application as it will appear in Datadog APM
  c.use :rails, service_name: ENV.fetch('DD_SERVICE', 'airpager')
  # (Optional) instrument other libraries:
  # c.use :redis, service_name: 'my-redis'
  # c.use :http, service_name: 'outbound-http'
end
