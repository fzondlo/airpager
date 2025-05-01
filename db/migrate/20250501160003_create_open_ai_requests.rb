class CreateOpenAiRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :open_ai_requests do |t|
      t.text :prompt
      t.text :answer
      t.jsonb :response_payload

      t.timestamps
    end
  end
end
