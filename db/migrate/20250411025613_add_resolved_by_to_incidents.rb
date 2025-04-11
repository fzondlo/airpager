class AddResolvedByToIncidents < ActiveRecord::Migration[8.0]
  def change
    add_column :incidents, :resolved_by, :string
  end
end
