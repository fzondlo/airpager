class Task
  module Mapping

    LIST_NAMES_TO_ID = {
      reservas: '901311254964',
      limpiezas: '901311220753'
    }

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
      limpiadora: "354e3ebf-dc3d-450a-8426-d4c6c421551f"
    }.freeze

    # Property Name IDs for Custom Field Ids
    PROPERTIES = [
      {
        name: "Murano 901",
        custom_field_id: "d2aee479-0c39-4d28-bab5-88b708b0c0fd",
        address: "Cra 75# 40-23\nApt 901\nEdificio Murano San martin\nLaureles- Estadio\nMedellín, Antioquia",
        google_maps: "https://maps.app.goo.gl/qdiDviTmWWZVL1Mr6"
      },
      {
        name: "Lauret 902",
        custom_field_id: "79168bfd-d7cf-462a-a236-5908ac9ba7bc",
        address: "CRA 72 #39A - 22,\nApt 902\nEdificio Lauret\nLaureles - Estadio\nMedellín, Antioquia",
        google_maps: "https://maps.app.goo.gl/aVHVDAGXNM24Ew7YA"
      },
      {
        name: "Nebraska 1101",
        custom_field_id: "9813fd45-359f-4d37-ba6b-c3084e5a9b8c",
        address: "Cq. 73A #34a-60\nApt 1101\nEdificio Nebraska\nLaureles - Estadio, Medellín, Laureles",
        google_maps: "https://maps.app.goo.gl/7ntzytCkPDMChEN8A"
      },
      {
        name: "Santa Ana 1001 (Alan)",
        custom_field_id: "d56ba8d9-49e0-4ed2-bbd5-ca9526ac1703",
        address: "Cq. 73A #39-68\nApt 1001 \nEdificio Santa Ana \nLaureles Medellín",
        google_maps: "https://maps.app.goo.gl/fj9EyXgMoUGREz5GA"
      },
      {
        name: "Santa Maria 302 (Yuri)",
        custom_field_id: "be78e5a4-9623-4b0d-a61a-2e18d405b207",
        address: "Cra 77 #42-19\nApt 302\nEdificio Santa Maria de Fiore \nLaureles - Estadio, Medellín",
        google_maps: "https://maps.app.goo.gl/Dvtzu3oy8WAggEW7A"
      },
      {
        name: "Santa Maria 402 (Yuri)",
        custom_field_id: "0a52529d-51f1-48f6-b95c-5482a61cf34a",
        address: "Cra 77 #42-19\nApt 402\nEdificio Santa Maria de Fiore \nLaureles - Estadio, Medellín",
        google_maps: "https://maps.app.goo.gl/Dvtzu3oy8WAggEW7A"
      },
      {
        name: "Santa Maria 201 (Edgar)",
        custom_field_id: "0e3d2f39-f889-499c-869f-effd75bff830",
        address: "Cra 77 #42-19\nApt 201\nEdificio Santa Maria de Fiore \nLaureles - Estadio, Medellín",
        google_maps: "https://maps.app.goo.gl/Dvtzu3oy8WAggEW7A"
      },
      {
        name: "Castelmola 301 (Angela)",
        custom_field_id: "f90e68e4-ef41-45af-9652-ba2d0de46268",
        address: "Tv. 37 #63b-33, \nApt 301\nEdificio Castelmola\nLaureles - Estadio, Medellín",
        google_maps: "https://maps.app.goo.gl/Vu13uFrpPZoCgjjp7"
      }
    ].freeze

    CLEANING_STAFF = [
      {
        name: "Ale",
        custom_field_id: "923fa8f7-7eb7-4aca-883a-1849e908ef18",
        whatsapp_group: "120363377987360866@g.us",
        calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-1593/d9dc7b14fef585e"
      },
      {
        name: "Jenyfer",
        custom_field_id: "57841d0e-3e6a-4cde-8921-87f05d711715",
        whatsapp_group: "120363377989240467@g.us",
        calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-1573/2049ca5610260eb"
      },
      {
        name: "Johana",
        custom_field_id: "6ceb206c-b86f-4c5b-af1a-0b3a7adb4eb0",
        whatsapp_group: "120363415585932604@g.us",
        calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-1613/31885787b07f736"
      },
      {
        name: "Olga",
        custom_field_id: "9a6a3378-c1d7-48c1-bfa4-f793584d26e4",
        whatsapp_group: "120363354564826542@g.us",
        calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-1553/75cecf85c84c162"
      },
      {
        name: "Liliana",
        custom_field_id: "6c6f2821-0331-448a-a91c-c86cb91eb058",
        whatsapp_group: "120363418846854020@g.us",
        calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-1633/d675cd727b47417"
      }
    ].freeze

  end
end
