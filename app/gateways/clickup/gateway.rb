module Clickup
  class Gateway
    include HTTParty
    include SystemConfig
    base_uri "https://api.clickup.com"

    def initialize(api_token)
      self.class.headers "Authorization" => api_token,
                       "content-type" => "application/json",
                       "Accept" => "application/json"
    end

    def create_task(task, list_name)
      self.class.post(
        "/api/v2/list/#{LIST_NAMES_TO_ID[list_name]}/task",
        body: task.to_json
      )
    end

    def update_task(task_id, updates)
      self.class.put(
        "/api/v2/task/#{task_id}",
        body: updates.to_json
      )
    end

    def delete_task(task_id)
      self.class.delete("/api/v2/task/#{task_id}")
    end

    def find_task(task_id)
      response = self.class.get("/api/v2/task/#{task_id}")
      Response::FindTask.new(response.parsed_response)
    end

    def find_tasks(list_name, query_params = {})
      list = LIST_NAMES_TO_ID[list_name]
      query_params["page"] = 0
      tasks = []

      loop do
        response = self.class.get("/api/v2/list/#{list}/task", query: query_params)
        tasks_data = response.parsed_response["tasks"] || []

        tasks_data.each do |task|
          tasks << Response::FindTask.new(task)
        end
        
        break if response["last_page"] == true
        query_params["page"] += 1
      end

      tasks
    end

    def get_custom_fields_for(list_name)
      self.class.get("/api/v2/list/#{LIST_NAMES_TO_ID[list_name]}/field")
    end
  end
end
