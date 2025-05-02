class HospitableWebhooksController
  class ReservationUpdatedHandler
    def initialize(payload)
      # no-op
    end

    def perform
      SyncClickupReservationsWorker.perform_async
    end
  end
end
