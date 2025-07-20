module SystemConfig
  STAFF_ON_CALL = :frank

  STAFF_PHONE_NUMBERS = {
    frank: "573228953728",
    laura: "573015348775",
    angie: "573184418412"
  }.freeze

  WHATSAPP_FACTURA_GROUPS = {
    "120363401619194668@g.us" => "test",
    "120363411632014678@g.us" => "Edgar",
    "120363340520465060@g.us" => "Airbnb",
    "120363400773310990@g.us" => "Angela",
    "120363401730486616@g.us" => "Sara",
    "120363357444254649@g.us" => "Alan",
    "120363402028991064@g.us" => "Yuri",
    "120363400288549445@g.us" => "2024",
    "120363418474521633@g.us" => "2025",
    "120363417179080666@g.us" => "Bertha"
  }.freeze

  ALERT_INCIDENT_GROUP = "120363420427504586@g.us".freeze
  LOGGING_WA_GROUP = "120363418506911919@g.us".freeze

  LIST_NAMES_TO_ID = {
    reservas: "901311254964",
    limpiezas: "901311220753"
  }.freeze

  UPDATE_ACTIONS = {
    do_nothing: 0,
    create_new_records: 1,
    cancel: 2,
    cancel_and_rebook: 3
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
  # To know all available hospitable_ids, run in a rails console `Hospitable.gateway.find_properties.properties`
  PROPERTIES = [
    {
      name: "Murano 901",
      custom_field_id: "d2aee479-0c39-4d28-bab5-88b708b0c0fd",
      hospitable_id: "12c5c137-34c4-4264-82bb-2b6f20f568d4", #  {:id=>"12c5c137-34c4-4264-82bb-2b6f20f568d4", :name=>"Murano"},
      address: "Cra 75# 40-23\nApt 901\nEdificio Murano San Martin\nLaureles- Estadio\nMedellín, Antioquia",
      google_maps: "https://maps.app.goo.gl/qdiDviTmWWZVL1Mr6"
    },
    {
      name: "Lauret 902",
      custom_field_id: "79168bfd-d7cf-462a-a236-5908ac9ba7bc",
      hospitable_id: "2dffe1d8-960d-4b16-8521-7f3628d9ec33", # {:id=>"2dffe1d8-960d-4b16-8521-7f3628d9ec33", :name=>"Lauret"},
      address: "CRA 72 #39A - 22,\nApt 902\nEdificio Lauret\nLaureles - Estadio\nMedellín, Antioquia",
      google_maps: "https://maps.app.goo.gl/aVHVDAGXNM24Ew7YA"
    },
    {
      name: "Nebraska 1101",
      custom_field_id: "9813fd45-359f-4d37-ba6b-c3084e5a9b8c",
      hospitable_id: "9e22f207-2a63-4ba7-9a73-d3aca1da76d4", # {:id=>"9e22f207-2a63-4ba7-9a73-d3aca1da76d4", :name=>"Nebraska"}
      address: "Cq. 73A #34a-60\nApt 1101\nEdificio Nebraska\nLaureles - Estadio, Medellín, Laureles",
      google_maps: "https://maps.app.goo.gl/7ntzytCkPDMChEN8A"
    },
    {
      name: "Santa Ana 1001 (Alan)",
      custom_field_id: "d56ba8d9-49e0-4ed2-bbd5-ca9526ac1703",
      hospitable_id: "d6961b70-ce54-4d87-8023-266a0b182a80", # {:id=>"d6961b70-ce54-4d87-8023-266a0b182a80", :name=>"Alans Apartment"}
      address: "Cq. 73A #39-68\nApt 1001 \nEdificio Santa Ana \nLaureles Medellín",
      google_maps: "https://maps.app.goo.gl/fj9EyXgMoUGREz5GA"
    },
    {
      name: "Santa Maria 302 (Yuri)",
      custom_field_id: "be78e5a4-9623-4b0d-a61a-2e18d405b207",
      hospitable_id: "c70d62ee-6121-4db4-9fb0-c8afd8c7e12e", # {:id=>"c70d62ee-6121-4db4-9fb0-c8afd8c7e12e", :name=>"Modern Urban Apt w Designer"}
      address: "Cra 77 #42-19\nApt 302\nEdificio Santa Maria de Fiore \nLaureles - Estadio, Medellín",
      google_maps: "https://maps.app.goo.gl/Dvtzu3oy8WAggEW7A"
    },
    {
      name: "Santa Maria 402 (Yuri)",
      custom_field_id: "0a52529d-51f1-48f6-b95c-5482a61cf34a",
      hospitable_id: "45703d3e-5761-457c-956b-af7d9ddb0988", #  {:id=>"45703d3e-5761-457c-956b-af7d9ddb0988", :name=>"Santa Maria 402 Yuri"},
      address: "Cra 77 #42-19\nApt 402\nEdificio Santa Maria de Fiore \nLaureles - Estadio, Medellín",
      google_maps: "https://maps.app.goo.gl/Dvtzu3oy8WAggEW7A"
    },
    {
      name: "Santa Maria 201 (Edgar)",
      custom_field_id: "0e3d2f39-f889-499c-869f-effd75bff830",
      hospitable_id: "dc751389-06f9-43be-be80-c6cae8a4b51c", #  {:id=>"dc751389-06f9-43be-be80-c6cae8a4b51c", :name=>"Edgar 201"}
      address: "Cra 77 #42-19\nApt 201\nEdificio Santa Maria de Fiore \nLaureles - Estadio, Medellín",
      google_maps: "https://maps.app.goo.gl/Dvtzu3oy8WAggEW7A"
    },
    {
      name: "Castelmola 301 (Angela)",
      custom_field_id: "f90e68e4-ef41-45af-9652-ba2d0de46268",
      hospitable_id: "d7ac381c-e62b-482f-95ce-05c3301cfa04", # {:id=>"d7ac381c-e62b-482f-95ce-05c3301cfa04", :name=>"Angelas Apartment"}
      address: "Tv. 37 #63b-33, \nApt 301\nEdificio Castelmola\nLaureles - Estadio, Medellín",
      google_maps: "https://maps.app.goo.gl/Vu13uFrpPZoCgjjp7"
    },
    {
      name: "Castelmola 501 (Bertha)",
      custom_field_id: "2edca996-4981-4ed9-a2b5-96edd99ab186",
      hospitable_id: "dba79bc0-d496-4dfc-9f62-b1956da48f6e",
      address: "Tv. 37 #63b-33, \nApt 501\nEdificio Castelmola\nLaureles - Estadio, Medellín",
      google_maps: "https://maps.app.goo.gl/Vu13uFrpPZoCgjjp7"
    },
    {
      name: "Santa Maria 202",
      custom_field_id: "1172bd0a-f0f9-4fc9-a7db-7f2f92269a3a",
      hospitable_id: "9a4437c5-a071-4723-b195-131586acd529",
      address: "Cra 77 #42-19\nApt 202\nEdificio Santa Maria de Fiore \nLaureles - Estadio, Medellín",
      google_maps: "https://maps.app.goo.gl/Dvtzu3oy8WAggEW7A"
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
      name: "Doña Olga",
      custom_field_id: "9a6a3378-c1d7-48c1-bfa4-f793584d26e4",
      whatsapp_group: "120363354564826542@g.us",
      calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-1553/75cecf85c84c162"
    },
    {
      name: "Liliana",
      custom_field_id: "6c6f2821-0331-448a-a91c-c86cb91eb058",
      whatsapp_group: "120363418846854020@g.us",
      calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-1633/d675cd727b47417"
    },
    {
      name: "Alba",
      custom_field_id: "7ab1261c-1eca-4fe6-bb40-995b8ffcca54",
      whatsapp_group: "120363399851749931@g.us",
      calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-2013/e75f7e8fb6593fe"
    },
    {
      name: "Riaza",
      custom_field_id: "79a5abdb-1c34-4a57-847f-ef43520f5dae",
      whatsapp_group: "120363401428184525@g.us",
      calendar: "https://sharing.clickup.com/9013289879/b/h/8ckqrwq-2033/c1085fd3590b720"
    }
  ].freeze
end
