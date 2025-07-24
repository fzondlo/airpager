module ClickupMigrations
  class Migration1005 < Base
    # bundle exec rake clickup:migration 1005 up

    DESCRIPTION = <<~DESCRIPTION
        Remove all cleanings that don't have a cleaner assigned
      DESCRIPTION

    def migration_up
      all_cleanings.each do |task|
        if !cleaner_assigned?(task)
          delete_task(task)
          puts "DELETED Task ID: #{task.id} (cleaner is #{task.limpiadora})"
        else
          puts "Skipping Task ID #{task.id} (cleaner is #{task.limpiadora})"
        end
      end
    end

    private

    def cleaner_assigned?(task)
      !task.limpiadora.nil?
    end

    def all_cleanings
      @all_cleanings ||= Task.new.clean_tasks
    end

    def delete_task(task)
       Clickup.gateway.delete_task(task.id)
    end
  end
end
