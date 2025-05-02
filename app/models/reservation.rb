class Reservation

  UPDATE_ACTIONS = {
    do_nothing:          0,
    create_new_records:  1,
    cancel_reservation:  2,
    cancel_and_rebook:   3
  }.freeze

  def sync_clickup_tasks
    hospitable_reservations.each do |res|
      action = action_for_reservation[res[:id]]
      if action == UPDATE_ACTIONS[:do_nothing]
        puts "Skipping #{res[:code]}"
      elsif action == UPDATE_ACTIONS[:create_new_records]
        create_clickup_tasks(res)
      elsif action == UPDATE_ACTIONS[:cancel_reservation]
        cancel_clickup_tasks(res)
      end
    end
  end

  private

  def cancel_clickup_tasks(reservation)
    Clickup.gateway.update_task(
      find_clickup_task_id_by_reservation_id(clickup_reservations, reservation[:id]),
      { status: "cancelado" })
    Clickup.gateway.update_task(
      find_clickup_task_id_by_reservation_id(clickup_cleanings, reservation[:id]),
      { status: "cancelado" })
    puts "Reservation & Cleaning tasks cancelled for #{reservation[:code]}"
  end

  def find_clickup_task_id_by_reservation_id(task_list, reservation_id)
    task_list['tasks'].find do |task|
      reservation_id == task["custom_fields"]
        .select{|x| x["name"] == "reservation_id"}[0]["value"]
    end['id']
  end

  def create_clickup_tasks(reservation)
    Clickup.gateway.create_task(
      ClickupTaskBuilder.cleaning_task(reservation), :limpiezas)
    Clickup.gateway.create_task(
      ClickupTaskBuilder.reservation_task(reservation), :reservas)
    puts "Reservation & Cleaning tasks created for #{reservation[:code]}"
  end

  def action_for_reservation
    @action_for_reservation ||= begin

      # Build a hash mapping each reservation to its required action
      hospitable_reservations.each_with_object({}) do |hospitable_res, memo|
        memo[hospitable_res[:id]] =
          if hospitable_res[:status] == "accepted" &&
              task_reservation_status.keys.exclude?(hospitable_res[:id])
            UPDATE_ACTIONS[:create_new_records]
          elsif hospitable_res[:status] == "cancelled" &&
              task_reservation_status[hospitable_res[:id]] == "active"
            UPDATE_ACTIONS[:cancel_reservation]
          elsif hospitable_res[:status] == "accepted" &&
              task_reservation_status[hospitable_res[:id]] == "active"
            UPDATE_ACTIONS[:do_nothing]
          end
      end
    end
  end

  def task_reservation_status
    @task_reservation_status ||=
      clickup_reservations["tasks"].each_with_object({}) do |task, memo|
        reservation_id = task["custom_fields"]
                           .select{|x| x["name"] == "reservation_id"}[0]["value"]
        memo[reservation_id] = task['status']['status'] == "activo" ?
                                 "active" :
                                 "cancelled"
      end
  end

  def clickup_cleanings
    @all_limpiezas ||= Clickup.gateway.find_tasks(:limpiezas)
  end

  def clickup_reservations
    @all_reservas ||= Clickup.gateway.find_tasks(:reservas)
  end

  def cancelled_reservations
    hospitable_reservations.select{|x| x[:status] == "cancelled"}
  end

  def active_reservations
    hospitable_reservations.select{|x| x[:status] == "accepted"}
  end

  def hospitable_reservations
    @hospitable_reservations ||= Hospitable.gateway.find_reservations(
        Hospitable.gateway.find_properties.properties.pluck(:id)
      ).reservations
  end

  def custom_field(id, name, value)
    {
      "id": id,
      "name": name,
      "value": value
    }
  end
end
