require "uri"
require "net/http"

namespace :waapi do
  # bundle exec rake waapi:print_groups
  desc "Print all groups"
  task print_groups: [ :environment ] do
    chats = Waapi.gateway.find_all_chats
    chats["data"]["data"].each do |chat|
      next unless chat["groupMetadata"]
      group_name = chat["groupMetadata"]["subject"]
      group_id = chat["groupMetadata"]["id"]["_serialized"]
      puts "#{group_name} => #{group_id}"
    end
  end

  # bundle exec rake waapi:export_all_chats
  desc "Export all chats that whatsapp is part of"
  task export_all_chats: [ :environment ] do
    chats = Waapi.gateway.find_all_chats
    pretty_json = JSON.pretty_generate(chats)
    file_path = Rails.root.join("tmp", "all_chats.json")
    File.write(file_path, chats)
    puts "\n\nSuccess! Exported all chats to #{file_path}\n\n"
  end

  # bundle exec rake waapi:confirm_cleanings_tomorrow
  desc "Send messages for confirmation tomorrow"
  task confirm_cleanings_tomorrow: [ :environment ] do
    DayBeforeCleaningReminderWorker.new.perform
  end
end
