class AddUrgencyLevelToIncidents < ActiveRecord::Migration[8.0]
  def change
    add_column :incidents, :urgency_level, :string
    add_index :incidents, :urgency_level
  end
end
