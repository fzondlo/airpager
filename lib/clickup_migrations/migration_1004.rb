module ClickupMigrations
  class Migration1004 < Base
    # bundle exec rake clickup:migration 1003 up

    DESCRIPTION = <<~DESCRIPTION
        Change all limpiezas to use start date and due date
      DESCRIPTION

    def migration_up
      all_cleanings.each do |task|
        if needs_update?(task)
          update_task(task)
          puts "Task ID: #{task.id} updated"
        else
          puts "Skipping Task ID #{task.id}"
        end
      end
    end

    private

    def needs_update?(task)
      !!task.start_date && task.due_date.nil?
    end

    def all_cleanings
      @all_cleanings ||= Task.new.clean_tasks
    end

    def update_task(task)
      Clickup.gateway.update_task(
        task.id,
        { start_date_time: true,
          due_date_time: true,
          start_date: task.start_date,
          due_date: task.start_date
        }
      )
    end
  end
end
