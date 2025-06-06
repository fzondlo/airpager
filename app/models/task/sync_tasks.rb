class Task
  class SyncTasks
    include Task::Mapping

    def initialize(hospitable_reservations, action_for_reservation, tasks, task_type)
      @hospitable_reservations = hospitable_reservations
      @action_for_reservation = action_for_reservation
      @tasks = tasks
      @task_type = task_type
    end

    def sync
      @hospitable_reservations.each do |res|
        case @action_for_reservation[res[:id]]
        when UPDATE_ACTIONS[:create_new_records]
          create_task(res)
        when UPDATE_ACTIONS[:cancel]
          cancel_task(res)
        else
          # covers both :do_nothing and any unrecognized action
          puts "Skipping #{res[:code]}"
        end
      end
    end

    private

    def find_task_id(reservation_id)
      @tasks.find { |t| t.reservation_id == reservation_id }.id
    end

    def cancel_task(reservation)
      Clickup.gateway.update_task(
        find_task_id(reservation[:id]),
        { status: "cancelado" }
      )
      puts "Task cancelled for #{@task_type} #{reservation[:code]}"
    end

    def create_task(reservation)
      begin
        Clickup.gateway.create_task(
          TaskBuilder.new(reservation, @task_type).build,
          @task_type
        )
        puts "Tasks created for List: #{@task_type} Reservation Code: #{reservation[:code]}"
      rescue Task::TaskBuilder::PropertyNotFoundError => e
        puts "Error building task: #{e.message}"
      end
    end
  end
end
