module Clickup
  class Gateway
    include HTTParty
    base_uri "https://api.clickup.com"
    RESERVAS_LIST_ID = '901311254964'

    def initialize(api_token)
      self.class.headers "Authorization" => api_token,
                       "content-type" => "application/json",
                       "Accept" => "application/json"
    end

    def create_clickup_task(task)
      self.class.post(
        "/api/v2/list/#{RESERVAS_LIST_ID}/task",
        body: task.to_json
      )
    end

    def find_tasks()
      self.class.get("/api/v2/list/#{RESERVAS_LIST_ID}/task")
    end
  end
end
