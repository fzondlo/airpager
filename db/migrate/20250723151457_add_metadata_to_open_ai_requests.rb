class AddMetadataToOpenAiRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :open_ai_requests, :metadata, :jsonb
  end
end
