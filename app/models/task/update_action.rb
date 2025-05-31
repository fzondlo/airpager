class Task
  class UpdateAction
    include Task::Mapping

    def initialize(hospitable_reservations, tasks)
      @hospitable_reservations = hospitable_reservations
      @tasks = tasks
    end

    def actions_for_reservation_ids
      @hospitable_reservations.each_with_object({}) do |res, memo|
        memo[res[:id]] = determine_action_for(res)
      end
    end

    private

    def determine_action_for(res)
      case
      when accepted_without_task?(res)
        UPDATE_ACTIONS[:create_new_records]
      when cancelled_with_active_task?(res)
        UPDATE_ACTIONS[:cancel]
      else
        UPDATE_ACTIONS[:do_nothing]
      end
    end

    def accepted_without_task?(res)
      res[:status] == "accepted" && !task_reservation_status.key?(res[:id])
    end

    def cancelled_with_active_task?(res)
      res[:status] == "cancelled" && task_reservation_status[res[:id]] == "active"
    end

    #returns hash of reservation ids with status either "active" or "cancelled"
    def task_reservation_status
      @task_reservation_status ||= @tasks.each_with_object({}) do |task, memo|
        cf = task["custom_fields"].find { |f| f["name"] == "reservation_id" }
        reservation_id = cf&.fetch("value", nil)
        next unless reservation_id

        status = task.dig("status", "status") == "activo" ? "active" : "cancelled"
        memo[reservation_id] = status
      end
    end
  end
end
