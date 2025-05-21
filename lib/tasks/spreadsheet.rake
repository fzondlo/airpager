require 'uri'
require 'net/http'
require "google/apis/sheets_v4"
require "logger"

namespace :spreadsheet do

  # bundle exec rake spreadsheet:add_row
  desc "Add a row in a spreadsheet as a test"
  task add_row: [:environment] do
    Google::Apis.logger = Logger.new($stdout)
    Google::Apis.logger.level = Logger::DEBUG

    SPREADSHEET_ID = "1O1t-wesNYbhr0AMMGENyUkjGAnOzmPjlwyEZFUA153M"
    SHEET_NAME     = "Receipts"   # make sure this tab exists exactly

    row = ["Name", "Date", "Amount"]
    value_range  = Google::Apis::SheetsV4::ValueRange.new(values: [row])

    begin
      GoogleDrive.gateway.sheets.append_spreadsheet_value(
        SPREADSHEET_ID,
        "#{SHEET_NAME}!A:C",
        value_range,
        value_input_option:  "USER_ENTERED",
        insert_data_option:   "INSERT_ROWS"
      )
    rescue Google::Apis::ClientError => e
      puts "API returned status #{e.status_code}"
      puts "Response body:\n#{e.body}"
      raise
    end
  end
end
