module ClickupMigrations
  class Migration1002 < Base
    OFFSET_MS = 18_000_000
    OFFSET_S = OFFSET_MS / 1_000.0
    # 1_746_522_000_000 - 1_746_504_000_000

    DESCRIPTION = <<~DESCRIPTION
        This will update the following boards: Limpieza and Reservas

        It will find any task that has a start_date set, set it to nil
        and then set the due date with an offset be exactly like a task created
        in clickup
      DESCRIPTION

    def migration_up
      tasks_to_update.each { |task| update_task(task) }
    end

    private

    def tasks_to_update
      # (all_cleanings + all_reservations).map do |task|
      #   task if !!task['start_date']
      # end.compact
    end

    def apply_offset(time)
      time.to_i + OFFSET_MS
    end

    # all_cleanings.select{|x| x['id'] == '86a8bppa7' }[0]["due_date"]
    # all_reservations.select{|x| x['id'] == '86a8wyatb' }[0]["due_date"]
    #
    # def target_task
    #   # was originally [{:start_date=>"1746504000000", :due_date=>"1746504000000"}]
    #   all_cleanings.select do |task|
    #     task['id'] == '86a8bprgx'
    #   end
    # end
    #
    # def demo_task
    #   all_cleanings.select do |task|
    #     task['id'] == '86a8wvz0k'
    #   end
    # end

    def all_cleanings
      @all_cleanings ||= Clickup.gateway.find_tasks(:limpiezas)["tasks"]
    end

    def all_reservations
      @all_reservations ||= Clickup.gateway.find_tasks(:reservas)["tasks"]
    end

    def update_task(task)
      Clickup.gateway.update_task(
        task["id"],
        { start_date_time: false,
          due_date_time: false,
          start_date: nil,
          due_date: apply_offset(task["due_date"])
        }
      )
      puts "Task ID: #{task['id']} Updated Successfully"
    end
  end
end
