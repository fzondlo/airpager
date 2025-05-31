class SyncClickupReservationsWorker
  include Sidekiq::Worker

  def perform
    Task.new.sync_all_tasks
  end
end
