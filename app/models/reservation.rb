class Reservation

    def self.perform
        @service ||= self.new
        @service.perform
    end

    def perform
        create_clickup_tasks(tasks_from_reservations)
    end

    private

    def tasks_from_reservations
        reservation_to_task(properties_with_reservations)
    end

    def properties_with_reservations
        properties = Hospitable.gateway.properties["data"] 
            .each_with_object({}) do |property, hash|
                hash[:id] = property[:id]
            end
        
        binding.pry

        properties.each do |property_id, property|    
            property[:reservations] = 
                Hospitable.gateway.reservations(property_id) 
        end
        properties
    end

    def reservation_to_task(properties_with_reservations)
        binding.pry
    end

    def create_clickup_task(task)
        url = URI("https://api.clickup.com/api/v2/list/901311254964/task")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["accept"] = 'application/json'
        request["content-type"] = 'application/json'
        request["Authorization"] = 'pk_90890623_AOHP22BP3Y8HD22AP5AYVXGF8V763R9F'
        request.body = {
            "name": "New Task Name",
            "description": "New Task Description",
            "markdown_description": "New Task Description",
            "assignees": [
                
            ],
            "archived": false,
            "group_assignees": [
            ],
            "email_assignees": [
            ],
            "tags": [
                "tag name 1"
            ],
            "status": "TO DO",
            "priority": 3,
            "due_date": 1508369194377,
            "due_date_time": false,
            "time_estimate": 8640000,
            "start_date": 1567780450202,
            "start_date_time": false,
            "notify_all": true,
            "parent": nil,
            "links_to": nil,
            "check_required_custom_fields": true,
            "custom_fields": [
                {
                    "id": "0a52c486-5f05-403b-b4fd-c512ff05131c",
                    "value": "This is a string of text added to a Custom Field."
                }
            ]
        }.to_json

        response = http.request(request)
        puts response.read_body
    end
end