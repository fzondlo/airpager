class AddDetailsToOpenAiRequests < ActiveRecord::Migration[8.0]
  def change
    change_table :open_ai_requests do |t|
      t.string :request_id
      t.string :request_type # instead of 'type' to avoid STI conflict
      t.string :model
      t.text :system_prompt
      t.boolean :success, default: true, null: false
      t.jsonb :response_headers
    end

    rename_column :open_ai_requests, :prompt, :user_prompt
  end
end
