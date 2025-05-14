require 'uri'
require 'net/http'

namespace :waapi do

  # bundle exec rake waapi:export_all_chats
  desc "Export all chats that whatsapp is part of"
  task export_all_chats: [:environment] do
    chats = Waapi.gateway.find_all_chats
    pretty_json = JSON.pretty_generate(chats)
    file_path = Rails.root.join("tmp", "all_chats.json")
    File.write(file_path, pretty_json)
    puts "\n\nSuccess! Exported all chats to #{file_path}\n\n"
  end
end
