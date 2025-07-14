require "csv"

##
# To run this task on production and download the file generated, run the following command:
#
# For messages:
# $ heroku run 'bash -c "rake export:messages && cat tmp/messages_export.csv"' --app airpager > messages_export.csv
#
# For messages_questions
# $ heroku run 'bash -c "rake export:messages_questions && cat tmp/messages_questions_export.csv"' --app airpager > messages_questions_export.csv
#
# Notes: The start of the file downloaded has some junk in it from the STDOUT, you'll need to drop it manually with an editor like Sublimetext.
##

namespace :export do
  desc "Export all messages to CSV"
  task messages: :environment do
    puts "Exporting messages to CSV..."

    file_path = Rails.root.join("tmp", "messages_export.csv")

    CSV.open(file_path, "wb") do |csv|
      csv << %w[
        id
        conversation_id
        reservation_id
        sender_role
        sender_full_name
        content
        posted_at
        created_at
        updated_at
      ]

      Message.find_each do |message|
        csv << [
          message.id,
          message.conversation_id,
          message.reservation_id,
          message.sender_role.presence || "guest",
          message.sender_full_name,
          message.content,
          message.posted_at,
          message.created_at,
          message.updated_at
        ]
      end
    end

    puts "Done. File saved at #{file_path}"
  end

  desc "Export messages that are questions to CSV"
  task messages_questions: :environment do
    puts "Exporting questions to CSV..."

    file_path = Rails.root.join("tmp", "messages_questions_export.csv")

    CSV.open(file_path, "wb") do |csv|
      csv << %w[
        id
        conversation_id
        reservation_id
        sender_role
        sender_full_name
        content
        posted_at
        created_at
        updated_at
      ]

      Message.find_each do |message|
        next unless message.content&.strip&.ends_with?("?")

        csv << [
          message.id,
          message.conversation_id,
          message.reservation_id,
          message.sender_role.presence || "guest",
          message.sender_full_name,
          message.content,
          message.posted_at,
          message.created_at,
          message.updated_at
        ]
      end
    end

    puts "Done. File saved at #{file_path}"
  end
end
