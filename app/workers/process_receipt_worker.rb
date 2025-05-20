class ProcessReceiptWorker
  include Sidekiq::Worker

  def perform(group, group_id, base64_image)
    @image = base64_image
    @group = group
    Waapi.gateway.send_message(message, group_id)
  end

  private

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
