class Task
  class TaskBuilder
    include SystemConfig

    class PropertyNotFoundError < StandardError; end

    def initialize(reservation, task_type)
      @reservation   = reservation
      @property      = reservation[:property]
      @guest         = reservation[:guest]
      @task_type     = task_type
    end

    def build
      {
        name: task_name,
        # tags: [@property[:name]],
        status: "Activo", ## For clickup, also Cancelado
        start_date: start_date,
        start_date_time: true,
        due_date: due_date,
        due_date_time: true,
        check_required_custom_fields: true,
        custom_fields: build_custom_fields
      }
    end

    private

    def clickup_timestamp(timestamp)
      # clickup loses it's mind if the timestamp is not at 4am
      timestamp.change(hour: 4).to_i * 1000
    end

    def start_date
      if @task_type == :limpiezas
        clickup_timestamp(@reservation[:departure_time])
      else
        clickup_timestamp(@reservation[:arrival_time])
      end
    end

    def due_date
      clickup_timestamp(@reservation[:departure_time])
    end

    def task_name
      "#{@property[:name]} – #{@guest[:first_name]} #{@guest[:last_name]}"
    end

    def build_custom_fields
      [
        cf(:infant_count, "infant_count", @reservation[:infant_count].to_i),
        cf(:reservation_code, "reservation_code", @reservation[:code]),
        cf(:reservation_id, "reservation_id", @reservation[:id]),
        cf(:nights, "nights", @reservation[:nights]),
        cf(:property_id, "property_id", @reservation[:property_id]),
        cf(:property_name, "property_name", get_property_id(@property[:name])),
        cf(:guest_name, "guest_name", "#{@guest[:first_name]} #{@guest[:last_name]}"),
        cf(:guest_lang, "guest_language", @guest[:language]),
        cf(:guest_loc, "guest_location", @guest[:location]),
        cf(:schedule_cleaning_on, "Fetcha para agendar limpieza",
           clickup_timestamp(@reservation[:departure_time] - 14.days))
      ]
    end

    def get_property_id(name)
      mapped_property = PROPERTIES.find { |p| p[:name] == name }
      if mapped_property
        mapped_property[:custom_field_id]
      else
        raise PropertyNotFoundError, "Property not found for Property #{name} & Reservation #{@reservation[:code]}"
      end
    end

    def cf(field_id, field_name, value)
      { id: CUSTOM_FIELD_IDS[field_id], name: field_name, value: value }
    end
  end
end
