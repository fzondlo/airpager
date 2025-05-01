class Reservation

  UPDATE_ACTIONS = {
    do_nothing:          0,
    create_new_records:  1,
    cancel_reservation:  2,
    cancel_and_rebook:   3
  }.freeze

  def create_clickup_tasks
    active_reservations.each do |res|
      if action_for_reservation[res[:id]] == UPDATE_ACTIONS[:do_nothing]
        puts "Skipping #{res[:code]}"
      else
        Clickup.gateway.create_clickup_task(
          ClickupTaskBuilder.cleaning_task(res), :limpiezas)

        Clickup.gateway.create_clickup_task(
          ClickupTaskBuilder.reservation_task(res), :reservas)

        puts "Reservation & Cleaning tasks created for #{res[:code]}"
      end
    end
  end

  private

  def action_for_reservation
    @action_for_reservation ||= begin
      # Collect all existing reservation IDs from task custom fields
      existing_ids = clickup_reservations["tasks"]
                       .flat_map { |task| task["custom_fields"] }
                       .select { |cf| cf["name"] == "reservation_id" }
                       .map    { |cf| cf["value"] }

      # Build a hash mapping each reservation to its required action
      hospitable_reservations.each_with_object({}) do |reservation, memo|
        memo[reservation[:id]] = if existing_ids.include?(reservation[:id])
                                   UPDATE_ACTIONS[:do_nothing]
                                 else
                                   UPDATE_ACTIONS[:create_new_records]
                                 end
      end
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
    @all_reservation ||= Hospitable.gateway.find_reservations(
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
