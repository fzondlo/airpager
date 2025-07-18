class CreateProperties < ActiveRecord::Migration[8.0]
  def up
    create_table :properties do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :address
      t.string :clickup_custom_field_id, null: false
      t.string :google_maps_url

      t.timestamps
    end

    add_index :properties, :clickup_custom_field_id, unique: true
    add_index :properties, :slug, unique: true

    # Initial seeding from existing hardcoded properties
    SystemConfig::PROPERTIES.each do |property|
      Property.create!(
        name: property[:name],
        clickup_custom_field_id: property[:custom_field_id],
        address: property[:address],
        google_maps_url: property[:google_maps]
      )
    end
  end

  def down
    drop_table :properties
  end
end
