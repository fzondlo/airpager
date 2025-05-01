class ClickupTaskBuilder
  # Custom field IDs
  INFANT_COUNT_ID     = "7a1b1c45-311e-4263-8e98-ad49380e764e".freeze
  RESERVATION_CODE_ID = "94a0b9ed-e562-4c1b-9e8b-f1d52b0f51cf".freeze
  RESERVATION_ID_ID   = "fa6c9901-9b21-4f6d-94f5-21c5d903ba47".freeze
  NIGHTS_ID           = "43946508-f103-4373-a810-af2976ee2f39".freeze
  PROPERTY_ID_ID      = "6faef2f7-a1b3-4587-b052-bf4683c55620".freeze
  PROPERTY_NAME_ID    = "61b17d76-5d6a-4116-a0e8-f16c7c9936e6".freeze
  GUEST_NAME_ID       = "de5c58c0-bc80-499d-96a1-2f34e47cc012".freeze
  GUEST_LANG_ID       = "6b9c77a5-010e-4eee-a45c-f8163ff0de3f".freeze
  GUEST_LOC_ID        = "2f6211a5-cbe8-4804-9bbb-3c51ade3e5b5".freeze

  def self.reservation_task(reservation:)
    new(reservation).build_reservation_task
  end

  def initialize(reservation)
    @reservation   = reservation
    @property      = reservation[:property]
    @guest         = reservation[:guest]
  end

  def build_reservation_task
    {
      name:                        task_name,
      tags:                        [@property[:name]],
      status:                      "TO DO",
      start_date:                  timestamp_ms(@reservation[:arrival_date]),
      start_date_time:             false,
      due_date:                    timestamp_ms(@reservation[:departure_date]),
      due_date_time:               false,
      check_required_custom_fields: true,
      custom_fields:               build_custom_fields
    }
  end

  private

  def task_name
    "#{@property[:name]} – #{@guest[:first_name]} #{@guest[:last_name]}"
  end

  def timestamp_ms(date_str)
    Time.parse(date_str).to_i * 1_000
  end

  def build_custom_fields
    [
      cf(INFANT_COUNT_ID,     "infant_count",     @reservation[:infant_count].to_i),
      cf(RESERVATION_CODE_ID, "reservation_code", @reservation[:code]),
      cf(RESERVATION_ID_ID,   "reservation_id",   @reservation[:id]),
      cf(NIGHTS_ID,           "nights",           @reservation[:nights]),
      cf(PROPERTY_ID_ID,      "property_id",      @reservation[:property_id]),
      cf(PROPERTY_NAME_ID,    "property_name",    @property[:name]),
      cf(GUEST_NAME_ID,       "guest_name",       "#{@guest[:first_name]} #{@guest[:last_name]}"),
      cf(GUEST_LANG_ID,       "guest_language",   @guest[:language]),
      cf(GUEST_LOC_ID,        "guest_location",   @guest[:location])
    ]
  end

  def cf(field_id, field_name, value)
    { id: field_id, name: field_name, value: value }
  end
end
