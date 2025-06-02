class HospitableWebhooksController
  class ReservationCreatedHandler
    def initialize(payload)
      # no-op
    end

    def perform
      SyncClickupReservationsWorker.perform_async
      SyncClickupReservationsWorker.perform_in(2.minutes)
    end
  end
end
