class SyncClickupReservationsWorker
  include Sidekiq::Worker

  def perform
    Reservation.new.create_clickup_tasks
  end
end
