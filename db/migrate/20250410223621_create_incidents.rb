class CreateIncidents < ActiveRecord::Migration[8.0]
  def change
    create_table :incidents do |t|
      t.jsonb :source_details
      t.string :status, default: "created", null: false
      t.string :kind, null: false
      t.datetime :alerted_at
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
