class ProcessReceiptWorker
  include Sidekiq::Worker
  SPREADSHEET_IDS = {
    "2024" => "1O1t-wesNYbhr0AMMGENyUkjGAnOzmPjlwyEZFUA153M",
    "2025" => "1hA3LtzZxpWJ1sntUYTOa3kNi4Qop94AODzHtet7ajcs"
  }
  SHEET_NAME     = "Receipts"

  def perform(group, group_id, base64_image)
    @image = base64_image
    @group = group
    add_to_spreadsheet if SPREADSHEET_IDS.keys.include?(group)
    Waapi.gateway.send_message(message, group_id)
  end

  private

  def add_to_spreadsheet
    row = [
      receipt.date,
      receipt.vendor_name,
      receipt.cop,
      receipt.usd,
      receipt.description,
      image_url
    ]
    value_range  = Google::Apis::SheetsV4::ValueRange.new(values: [ row ])

    begin
      GoogleDrive.gateway.sheets.append_spreadsheet_value(
        SPREADSHEET_IDS[@group],
        "#{SHEET_NAME}!A:F",
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

  def message
    <<~TEXT
      Hola,

      Soy Smarty, la inteligencia artifical de MedellinBnB.

      Acabo de ver que subiste una factura para la cuenta de #{@group}.

      Ya la guardé para que nunca se pierda. Aqui esta el link:
      #{image_url}

      Y intente sacar estos datos:
      Fetcha de factura: #{receipt.date}
      Costo en COP: #{receipt.cop}
      Costo en USD: #{receipt.usd}
      Descripcion de factura: #{receipt.description}

      Tambien puedes copiar esto por la tabla:

      `#{receipt.description}\t#{receipt.cop}\t#{receipt.date}\t#{image_url}`
    TEXT
  end

  def receipt
    @receipt ||= begin
         OpenAi.gateway.process_receipt(Prompt.process_receipt, @image)
       rescue => e
         puts("chatgpt failed with #{e}")
         OpenStruct.new
       end
    end

  def image_url
    @image_url ||= GoogleDrive.gateway.create_image(@image, @group)
  end
end
