class Reservation

  def create_clickup_tasks
    reservation_tasks.each do |task|
      create_clickup_task(task)
    end
  end

  private

  def reservation_tasks
    reservations.map do |reservation|
      property = reservation[:property]
      guest = reservation[:guest]
      start_time = DateTime.parse(reservation[:arrival_date]).to_i * 1000
      due_date = DateTime.parse(reservation[:departure_date]).to_i * 1000

      {
        "name": "#{property[:name]} - #{guest[:first_name]} #{guest[:last_name]}",
        # "description": description,
        # "markdown_description": "New Task Description",
        # "assignees": [
        #
        # ],
        # "archived": false,
        # "group_assignees": [
        # ],
        # "email_assignees": [
        # ],
        "tags": [
          property[:name]
        ],
        "status": "TO DO",
        # "priority": 3,
        # "time_estimate": 8640000,
        "start_date": start_time,
        "start_date_time": false,
        "due_date": due_date,
        "due_date_time": false,
        # "notify_all": true,
        # "parent": nil,
        # "links_to": nil,
        "check_required_custom_fields": true,
        "custom_fields": [
          {
            "id": "0a52c486-5f05-403b-b4fd-c512ff05131c",
            "value": "This is a string of text added to a Custom Field."
          }
        ]
      }.to_json
    end
  end

  def reservations
    properties = Hospitable.gateway.find_properties.properties
    Hospitable.gateway.find_reservations(properties.pluck(:id)).reservations
  end

  def create_clickup_task(task)
    url = URI("https://api.clickup.com/api/v2/list/901311254964/task")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request["Authorization"] = 'pk_90890623_AOHP22BP3Y8HD22AP5AYVXGF8V763R9F'
    request.body = task

    response = http.request(request)
    puts response.read_body
  end
end
