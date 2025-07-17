class AddLiveEnabledToAutoReplies < ActiveRecord::Migration[8.0]
  def change
    add_column :auto_replies, :live_enabled, :boolean, default: false, null: false
  end
end
