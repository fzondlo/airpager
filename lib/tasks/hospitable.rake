require 'uri'
require 'net/http'

namespace :hospitable do

    # bundle exec rake hospitable:populate_clickup_calendar
    desc "Populate the clickup calendar with all the airbnb reservations"
    task populate_clickup_calendar: [:environment] do
        Reservation.perform
    end
end