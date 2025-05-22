class ClickupTaskBuilder
  # Custom field IDs
  INFANT_COUNT_ID = "7a1b1c45-311e-4263-8e98-ad49380e764e".freeze
  RESERVATION_CODE_ID = "94a0b9ed-e562-4c1b-9e8b-f1d52b0f51cf".freeze
  RESERVATION_ID_ID = "fa6c9901-9b21-4f6d-94f5-21c5d903ba47".freeze
  NIGHTS_ID = "43946508-f103-4373-a810-af2976ee2f39".freeze
  PROPERTY_ID_ID = "6faef2f7-a1b3-4587-b052-bf4683c55620".freeze
  GUEST_NAME_ID = "de5c58c0-bc80-499d-96a1-2f34e47cc012".freeze
  GUEST_LANG_ID = "6b9c77a5-010e-4eee-a45c-f8163ff0de3f".freeze
  GUEST_LOC_ID = "2f6211a5-cbe8-4804-9bbb-3c51ade3e5b5".freeze
  PROPERTY_NAME_ID = "ae0bf089-d100-4dbb-a455-c9fc041270d4".freeze
  SCHEDULE_CLEANING_ON = "96745ccb-7cfb-4604-a47a-3e0b2866c11e".freeze

  # Property Name IDs for Dropdown Options
  PROPERTY_NAME_OPTION_IDS = {
    "Murano 901" => "d2aee479-0c39-4d28-bab5-88b708b0c0fd",
    "Lauret 902" => "79168bfd-d7cf-462a-a236-5908ac9ba7bc",
    "Santa Ana 1001 (Alan)" => "d56ba8d9-49e0-4ed2-bbd5-ca9526ac1703",
    "Santa Maria 301 (Yuri)" => "be78e5a4-9623-4b0d-a61a-2e18d405b207",
    "Nebraska 1101" => "9813fd45-359f-4d37-ba6b-c3084e5a9b8c",
  }

  def self.reservation_task(reservation)
    new(reservation, :reservation).build_reservation_task
  end

  def self.cleaning_task(reservation)
    new(reservation, :cleaning).build_reservation_task
  end

  def initialize(reservation, task_type)
    @reservation   = reservation
    @property      = reservation[:property]
    @guest         = reservation[:guest]
    @task_type     = task_type
  end

  def build_reservation_task
    {
      name: task_name,
      # tags: [@property[:name]],
      status: "Activo", ## For reservations, also Cancelado
      start_date: start_time,
      start_date_time: true,
      due_date: due_time,
      due_date_time: true,
      check_required_custom_fields: true,
      custom_fields: build_custom_fields
    }
  end

  private

  def start_time
    @task_type == :cleaning ?
      timestamp_ms(@reservation[:departure_time]) :
      timestamp_ms(@reservation[:arrival_time])
  end

  def due_time
    @task_type == :cleaning ?
      timestamp_ms(@reservation[:departure_time] + 4.hours) :
      timestamp_ms(@reservation[:departure_time])
  end

  def task_name
    "#{@property[:name]} – #{@guest[:first_name]} #{@guest[:last_name]}"
  end

  def timestamp_ms(date)
    date.to_i * 1_000
  end

  def build_custom_fields
    [
      cf(INFANT_COUNT_ID,     "infant_count",     @reservation[:infant_count].to_i),
      cf(RESERVATION_CODE_ID, "reservation_code", @reservation[:code]),
      cf(RESERVATION_ID_ID,   "reservation_id",   @reservation[:id]),
      cf(NIGHTS_ID,           "nights",           @reservation[:nights]),
      cf(PROPERTY_ID_ID,      "property_id",      @reservation[:property_id]),
      cf(PROPERTY_NAME_ID,    "property_name",    PROPERTY_NAME_OPTION_IDS[@property[:name]]),
      cf(GUEST_NAME_ID,       "guest_name",       "#{@guest[:first_name]} #{@guest[:last_name]}"),
      cf(GUEST_LANG_ID,       "guest_language",   @guest[:language]),
      cf(GUEST_LOC_ID,        "guest_location",   @guest[:location]),
      cf(SCHEDULE_CLEANING_ON, "Fetcha para agendar limpieza",
         timestamp_ms(@reservation[:departure_time] - 14.days))
    ]
  end

  def cf(field_id, field_name, value)
    { id: field_id, name: field_name, value: value }
  end
end
