class HospitableWebhooksController
  class ReservationCreatedHandler
    def initialize(payload)
      # no-op
    end

    def perform
      Reservation.new.create_clickup_tasks
    end
  end
end
