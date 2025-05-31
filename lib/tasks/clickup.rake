require 'uri'
require 'net/http'

namespace :clickup do

  # bundle exec rake clickup:tags
  desc "Output all tags"
  task tags: :environment do
    raw_json = Clickup.gateway.get_custom_fields_for(:reservas).body
    parsed  = JSON.parse(raw_json)

    puts JSON.pretty_generate(parsed)
  end

  # bundle exec rake clickup:export_all_tasks
  desc "Export all clickup tasks"
  task export_all_tasks: :environment do
    timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%S")

    cleaning_tasks = Task.new.clean_tasks
    file_name = Rails.root.join("tmp", "#{timestamp}-cleaning-tasks.txt")
    File.write(file_name, JSON.pretty_generate(cleaning_tasks))
    puts "Cleaning tasks exported to #{file_name}"

    res_tasks = Task.new.res_tasks
    file_name = Rails.root.join("tmp", "#{timestamp}-res-tasks.txt")
    File.write(file_name, JSON.pretty_generate(res_tasks))
    puts "Reservation tasks exported to #{file_name}"
  end
end
