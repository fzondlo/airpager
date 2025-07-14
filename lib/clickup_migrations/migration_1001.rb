module ClickupMigrations
  class Migration1001 < Base
    DESCRIPTION = <<~DESCRIPTION
        This will update the following boards: Limpieza and Reservas

        It will find any task that has a due_date_time or a start_date_time
        that is set to a unix time stamp, and update them to TRUE
      DESCRIPTION

    def migration_up
      task_ids_to_update.each { |id| update_task(id) }
    end

    private

    def task_ids_to_update
      # unfortunately this check does nothing as the Api does not return the
      # start_date_time or due_date_time, so we are flying blind
      all_cleanings.map do |task|
        task["id"] if task["start_date_time"] != true
      end.compact
    end

    def all_cleanings
      @all_cleanings ||= Clickup.gateway.find_tasks(:limpiezas)["tasks"]
    end

    def all_reservations
      @all_reservations ||= Clickup.gateway.find_tasks(:reservas)["tasks"]
    end

    def update_task(id)
      Clickup.gateway.update_task(
        id,
        { start_date_time: true, due_date_time: true }
      )
      puts "Task ID: #{id} Updated Successfully"
    end
  end
end
