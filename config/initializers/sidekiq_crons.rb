EVERY_DAY = "0 0 * * *"

Sidekiq::Cron::Job.create(
  name: 'SyncClickupReservationsWorker',
  klass: 'SyncClickupReservationsWorker',
  cron: "#{EVERY_DAY} #{Time.zone.tzinfo.identifier}",
)
