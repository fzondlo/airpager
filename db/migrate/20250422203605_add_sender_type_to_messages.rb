class AddSenderTypeToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :sender_type, :string
  end
end
