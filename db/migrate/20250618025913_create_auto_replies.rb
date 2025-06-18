class CreateAutoReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :auto_replies do |t|
      t.text :trigger
      t.text :reply

      t.timestamps
    end
  end
end
