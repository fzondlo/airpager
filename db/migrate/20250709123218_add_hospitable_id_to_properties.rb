class AddHospitableIdToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :hospitable_id, :uuid
  end
end
