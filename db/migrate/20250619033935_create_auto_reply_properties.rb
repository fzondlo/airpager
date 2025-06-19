class CreateAutoReplyProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :auto_reply_properties do |t|
      t.references :auto_reply, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end

    add_index :auto_reply_properties, [:auto_reply_id, :property_id], unique: true
  end
end
