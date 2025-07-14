require "uri"
require "net/http"

namespace :hospitable do
    # bundle exec rake hospitable:populate_clickup_calendar
    desc "Populate the clickup calendar with all the airbnb clickup"
    task populate_clickup_calendar: [ :environment ] do
      Task.new.sync_all_tasks
    end
end
