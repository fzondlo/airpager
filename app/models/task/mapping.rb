class Task
  module Mapping

    UPDATE_ACTIONS = {
      do_nothing:          0,
      create_new_records:  1,
      cancel:  2,
      cancel_and_rebook:   3
    }.freeze

    # Custom field IDs
    CUSTOM_FIELD_IDS = {
      infant_count: "7a1b1c45-311e-4263-8e98-ad49380e764e",
      reservation_code: "94a0b9ed-e562-4c1b-9e8b-f1d52b0f51cf",
      reservation_id: "fa6c9901-9b21-4f6d-94f5-21c5d903ba47",
      nights: "43946508-f103-4373-a810-af2976ee2f39",
      property_id: "6faef2f7-a1b3-4587-b052-bf4683c55620",
      guest_name: "de5c58c0-bc80-499d-96a1-2f34e47cc012",
      guest_lang: "6b9c77a5-010e-4eee-a45c-f8163ff0de3f",
      guest_loc: "2f6211a5-cbe8-4804-9bbb-3c51ade3e5b5",
      property_name: "ae0bf089-d100-4dbb-a455-c9fc041270d4",
      schedule_cleaning_on: "96745ccb-7cfb-4604-a47a-3e0b2866c11e",
    }.freeze

    # Property Name IDs for Dropdown Options
    PROPERTY_NAME_OPTION_IDS = {
      "Murano 901" => "d2aee479-0c39-4d28-bab5-88b708b0c0fd",
      "Lauret 902" => "79168bfd-d7cf-462a-a236-5908ac9ba7bc",
      "Nebraska 1101" => "9813fd45-359f-4d37-ba6b-c3084e5a9b8c",
      "Santa Ana 1001 (Alan)" => "d56ba8d9-49e0-4ed2-bbd5-ca9526ac1703",
      "Santa Maria 302 (Yuri)" => "be78e5a4-9623-4b0d-a61a-2e18d405b207",
      "Santa Maria 402 (Yuri)" => "0a52529d-51f1-48f6-b95c-5482a61cf34a",
      "Santa Maria 201 (Edgar)" => "0e3d2f39-f889-499c-869f-effd75bff830",
      "Castelmola 301 (Angela)" => "f90e68e4-ef41-45af-9652-ba2d0de46268"
    }.freeze

  end
end
