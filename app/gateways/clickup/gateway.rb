module Clickup
  class Gateway
    include HTTParty
    base_uri "https://api.clickup.com"
    LIST_NAMES_TO_ID = {
      reservas: '901311254964',
      limpiezas: '901311220753'
    }


    def initialize(api_token)
      self.class.headers "Authorization" => api_token,
                       "content-type" => "application/json",
                       "Accept" => "application/json"
    end

    def create_clickup_task(task, list_name)
      self.class.post(
        "/api/v2/list/#{LIST_NAMES_TO_ID[list_name]}/task",
        body: task.to_json
      )
    end

    def find_tasks(list_name)
      list = LIST_NAMES_TO_ID[list_name]
      self.class.get("/api/v2/list/#{list}/task")
    end
  end
end
