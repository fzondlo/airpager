class SyncClickupReservationsWorker
  include Sidekiq::Worker

  def perform
    Reservation.new.sync_clickup_tasks
  end
end
