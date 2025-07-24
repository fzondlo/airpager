class AddTriggerContextToAutoReplies < ActiveRecord::Migration[8.0]
  def change
    change_table :auto_replies do |t|
      t.string :trigger_context, default: 'both', null: false
    end
  end
end
