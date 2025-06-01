class AssignedCleanerWorker
  include Sidekiq::Worker

  def perform(task_id, assigned_cleaner)
    @cleaner = assigned_cleaner.with_indifferent_access
    @assigned_cleaning = Clickup.gateway.find_task(task_id)

    Waapi.gateway.send_message(message, @cleaner[:whatsapp_group])
  end

  private

  def next_cleanings
    @next_cleanings ||= Task.new.next_task_for_cleaner(
      @cleaner[:custom_field_id]
    ).first(3)
  end

  def cleaning_text(task)
    "- #{task.due_date_readable} - #{task.property_name}"
  end

  def message
    <<~MESSAGE
        Hola #{@cleaner[:name]},

        *Te hemos asignado la siguiente limpieza:*
        #{cleaning_text(@assigned_cleaning)}

        *Tambien puedes ver tu calendario cumpleto aqui:*
        #{@cleaner[:calendar]}

        *Y aqui tienes las proximas 3 limpiezas:*
        #{next_cleanings.map { |x| cleaning_text(x) }.join("\n")}
    MESSAGE
  end
end
