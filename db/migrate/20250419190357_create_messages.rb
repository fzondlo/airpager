class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :conversation_id, null: false
      t.string :reservation_id
      t.string :sender_role
      t.string :sender_full_name
      t.text :content
      t.datetime :posted_at

      t.timestamps
    end
  end
end
