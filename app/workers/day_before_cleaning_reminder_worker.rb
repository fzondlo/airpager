class DayBeforeCleaningReminderWorker
  include Sidekiq::Worker
  include Task::Mapping

  def perform
    Task.new.cleanings_tomorrow.each do |task|
      cleaner = find_cleaner(task)
      property = find_property(task.property_id)

      Waapi.gateway.send_message(
        message(cleaner, property),
        cleaner[:whatsapp_group])
    end
  end

  private

  def find_property(property_id)
    PROPERTIES.find { |p| p[:custom_field_id] == property_id }
  end

  def find_cleaner(task)
    CLEANING_STAFF.find { |c| c[:custom_field_id] == task.limpiadora_id }
  end

  def message(cleaner, property)
    <<~MESSAGE
      Buenos dias #{cleaner[:name]}!

      Tienes esta limpieza el dia de manana:

      #{property[:address]}
      #{property[:google_maps]}

      Nos puedes confirma si puedes asistir?
    MESSAGE
  end
end
