class AddDetailsToAutoReplyUsages < ActiveRecord::Migration[8.0]
  def change
    add_column :auto_reply_usages, :usage_type, :string, null: false, default: 'sandbox'
    add_column :auto_reply_usages, :reservation_id, :string
    add_column :auto_reply_usages, :message_trigger_id, :string
    add_column :auto_reply_usages, :suggested_reply, :text

    add_index :auto_reply_usages, :conversation_id
    add_index :auto_reply_usages, :reservation_id
    add_index :auto_reply_usages, :usage_type
  end
end
