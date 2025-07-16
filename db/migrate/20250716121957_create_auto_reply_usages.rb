class CreateAutoReplyUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :auto_reply_usages do |t|
      t.string :conversation_id, null: false
      t.references :auto_reply, foreign_key: true, null: false

      t.timestamps
    end
  end
end
