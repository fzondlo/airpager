class Reservation

  def create_clickup_tasks
    all_reservations.each do |reservation|
      Clickup.gateway.create_clickup_task(
        cleaning_task(reservation), :limpiezas)

      Clickup.gateway.create_clickup_task(
        reservation_task(reservation), :reservas)

      puts "Reservation & Cleaning tasks created for #{reservation[:code]}"
    end

    # tasks = Clickup.gateway.find_tasks(:limpiezas)
    # binding.pry
  end

  private

  def all_reservations
    properties = Hospitable.gateway.find_properties.properties
    Hospitable.gateway.find_reservations(properties.pluck(:id)).reservations
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

  def reservation_task(reservation)
    property = reservation[:property]
    guest = reservation[:guest]
    start_time = DateTime.parse(reservation[:arrival_date]).to_i * 1000
    due_date = DateTime.parse(reservation[:departure_date]).to_i * 1000

    {
      "name": "#{property[:name]} - #{guest[:first_name]} #{guest[:last_name]}",
      "tags": [
        property[:name]
      ],
      "status": "TO DO",
      # "priority": 3,
      "start_date": start_time,
      "start_date_time": false,
      "due_date": due_date,
      "due_date_time": false,
      "check_required_custom_fields": true,
      "custom_fields": [
        custom_field("7a1b1c45-311e-4263-8e98-ad49380e764e",
                     "infant_count", reservation[:infant_count].to_i,),
        custom_field("94a0b9ed-e562-4c1b-9e8b-f1d52b0f51cf",
                     "reservation_code", reservation[:code]),
        custom_field("fa6c9901-9b21-4f6d-94f5-21c5d903ba47",
                     "reservation_id", reservation[:id],),
        custom_field("43946508-f103-4373-a810-af2976ee2f39", "nights",
                     reservation[:nights],),
        custom_field("6faef2f7-a1b3-4587-b052-bf4683c55620", "property_id",
                     reservation[:property_id],),
        custom_field("61b17d76-5d6a-4116-a0e8-f16c7c9936e6",
                     "property_name", property[:name]),
        custom_field("de5c58c0-bc80-499d-96a1-2f34e47cc012",
                     "guest_name",
                     "#{guest[:first_name]} #{guest[:last_name]}",),
        custom_field("6b9c77a5-010e-4eee-a45c-f8163ff0de3f",
                     "guest_language", guest[:language]),
        custom_field("2f6211a5-cbe8-4804-9bbb-3c51ade3e5b5",
                     "guest_location", guest[:location]),
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
