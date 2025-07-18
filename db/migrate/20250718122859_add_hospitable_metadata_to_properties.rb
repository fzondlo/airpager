class AddHospitableMetadataToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :hospitable_metadata, :jsonb, default: {}, null: false
  end
end
