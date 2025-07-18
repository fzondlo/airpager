EVERY_HOUR = "0 * * * *"
AT_8_30_AM  = "30 8 * * *"
AT_11_AM    = "0 11 * * *"
TIME_ZONE   = Time.zone.tzinfo.identifier

Sidekiq::Cron::Job.create(
  name:  "SyncClickupReservationsWorker – EVERY_HOUR",
  klass: "SyncClickupReservationsWorker",
  cron:  "#{EVERY_HOUR} #{TIME_ZONE}"
)

# Run at 8:30 AM every day
Sidekiq::Cron::Job.create(
  name:  "DayOfCleaningReminderWorker – 8:30am",
  klass: "DayOfCleaningReminderWorker",
  cron:  "#{AT_8_30_AM} #{TIME_ZONE}"
)

# Run at 8:30 AM every day
Sidekiq::Cron::Job.create(
  name:  "MessagesRespondedYesterdayWorker – 8:30am",
  klass: "MessagesRespondedYesterdayWorker",
  cron:  "#{AT_8_30_AM} #{TIME_ZONE}"
)

# Run at 11 AM every day
Sidekiq::Cron::Job.create(
  name:  "DayBeforeCleaningReminderWorker – 11am",
  klass: "DayBeforeCleaningReminderWorker",
  cron:  "#{AT_11_AM} #{TIME_ZONE}"
)
