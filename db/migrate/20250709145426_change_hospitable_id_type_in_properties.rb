class ChangeHospitableIdTypeInProperties < ActiveRecord::Migration[8.0]
  def up
    # We initially set hospitable_id as a UUID, but changed it to a string
    # because in tests we use simple IDs like "res-123", which are not valid UUIDs.
    # Keeping it as a string simplifies test data and avoids unnecessary complexity.
    change_column :properties, :hospitable_id, :string

    # Also add unique index since it should always be unique
    add_index :properties, :hospitable_id, unique: true
  end

  def down
    remove_index :properties, :hospitable_id
    remove_column :properties, :hospitable_id
    add_column :properties, :hospitable_id, :uuid
  end
end
