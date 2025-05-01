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
          cleaning_task(res), :limpiezas)

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
      existing_ids = all_reservas["tasks"]
                       .flat_map { |task| task["custom_fields"] }
                       .select { |cf| cf["name"] == "reservation_id" }
                       .map    { |cf| cf["value"] }

      # Build a hash mapping each reservation to its required action
      all_reservations.each_with_object({}) do |reservation, memo|
        memo[reservation[:id]] = if existing_ids.include?(reservation[:id])
                                   UPDATE_ACTIONS[:do_nothing]
                                 else
                                   UPDATE_ACTIONS[:create_new_records]
                                 end
      end
    end
  end

  def all_limpiezas
    @all_limpiezas ||= Clickup.gateway.find_tasks(:limpiezas)
  end

  def all_reservas
    @all_reservas ||= Clickup.gateway.find_tasks(:reservas)
  end

  def cancelled_reservations
    all_reservations.select{|x| x[:status] == "cancelled"}
  end

  def active_reservations
    all_reservations.select{|x| x[:status] == "accepted"}
  end

  def all_reservations
    @all_reservation ||= Hospitable.gateway.find_reservations(
        Hospitable.gateway.find_properties.properties.pluck(:id)
      ).reservations
  end

  def cleaning_task(reservation)
    property = reservation[:property]
    guest = reservation[:guest]
    due_date = DateTime.parse(reservation[:departure_date]).to_i * 1000
    activo_UUID = "5668a645-52c6-493f-b9b3-ed7e6c546fb1"

    {
      "name": "#{property[:name]} - #{guest[:first_name]} #{guest[:last_name]}",
      "tags": [
        property[:name]
      ],
      "status": "ACTIVO",
      # "priority": 3,
      "start_date_time": false,
      "due_date": due_date,
      "due_date_time": false,
      "check_required_custom_fields": true,
      "custom_fields": [
        # custom_field("354e3ebf-dc3d-450a-8426-d4c6c421551f",
        #              "Limpiadora", "",),
        custom_field("0c8a8eab-94bd-4aa3-88f9-1d49a962907d",
                     "Status", activo_UUID),
      ]
    }
  end

  def custom_field(id, name, value)
    {
      "id": id,
      "name": name,
      "value": value
    }
  end
end
