require 'csv'

##
# To run this task on production and download the file generated, run the following command:
#
# For messages:
# $ heroku run bash --app airpager -c 'FILE=$(rake export:messages | tail -n1) && cat "$FILE"' > messages.csv
#
# For messages_questions
# $ heroku run bash --app airpager -c 'FILE=$(rake export:messages_questions | tail -n1) && cat "$FILE"' > messages_questions.csv
##

namespace :export do
  desc "Export all messages to CSV"
  task messages: :environment do
    puts "Exporting messages to CSV..."

    file_path = Rails.root.join("tmp", "messages_export_#{Time.now.to_i}.csv")

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
          message.sender_role.presence || 'guest',
          message.sender_full_name,
          message.content,
          message.posted_at,
          message.created_at,
          message.updated_at,
        ]
      end
    end

    puts "Done. File saved at:"
    puts file_path
  end

  desc "Export messages that are questions to CSV"
  task messages_questions: :environment do
    puts "Exporting questions to CSV..."

    file_path = Rails.root.join("tmp", "messages_questions_export_#{Time.now.to_i}.csv")

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
          message.sender_role.presence || 'guest',
          message.sender_full_name,
          message.content,
          message.posted_at,
          message.created_at,
          message.updated_at,
        ]
      end
    end

    puts "Done. File saved at"
    puts file_path
  end
end
