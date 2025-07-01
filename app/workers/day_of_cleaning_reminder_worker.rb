class DayOfCleaningReminderWorker
  include Sidekiq::Worker
  include Task::Mapping

  sidekiq_options retry: false

  def perform
    Task.new.cleanings_today.each do |task|
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

  def next_cleanings(cleaner)
    Task.new.next_task_for_cleaner(
      cleaner[:custom_field_id]
    ).first(10)
  end

  def cleaning_text(task)
    "- #{task.due_date_readable} - #{task.property_name}"
  end

  def find_cleaner(task)
    CLEANING_STAFF.find { |c| c[:custom_field_id] == task.limpiadora_id }
  end

  def message(cleaner, property)
    <<~MESSAGE
      Buenos dias #{cleaner[:name]}!

      *Hoy tienes esta limpieza:*

      #{property[:address]}
      #{property[:google_maps]}

      Tambien puedes ver tu calendario cumpleto aqui:
      #{cleaner[:calendar]}

      Y aqui tienes las proximas limpiezas:
      #{next_cleanings(cleaner).map { |x| cleaning_text(x) }.join("\n")}
    MESSAGE
  end
end
