class WaapiWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  WHATSAPP_GROUP_IDS = {
    "120363401619194668@g.us" => "test",
    "120363411632014678@g.us" => "Edgar",
    "120363340520465060@g.us" => "Airbnb",
    "120363400773310990@g.us" => "Angela",
    "120363401730486616@g.us" => "Sara",
    "120363357444254649@g.us" => "Alan",
    "120363402028991064@g.us" => "Yuri"
  }

  def create
    return if !subscribed_to_group? || !contains_image?

    message = <<~TEXT
      Hola,

      Soy Smarty, la inteligencia artifical de MedellinBnB.

      Acabo de ver que subiste una factura para la cuenta de #{WHATSAPP_GROUP_IDS[group_id]}.

      Ya la guardé para que nunca se pierda. Aqui esta el link:
      #{image_url}

      Y intente sacar estos datos:
      Fetcha de factura: #{receipt.date}
      Costo en COP: #{receipt.cop}
      Costo en USD: #{receipt.usd}
      Descripcion de factura: #{receipt.description}
    TEXT

    Waapi.gateway.send_message(message, group_id)
  end

  private

  def receipt
    @receipt ||= OpenAi.gateway.process_receipt(Prompt.process_receipt, image)
  end

  def image_url
    @image_url ||= GoogleDrive.gateway.create_image(image, WHATSAPP_GROUP_IDS[group_id])
  end

  def contains_image?
    payload[:data][:media][:mimetype] == "image/jpeg"
  end

  def subscribed_to_group?
    !!WHATSAPP_GROUP_IDS[group_id]
  end

  def group_id
    payload[:data][:message][:_data][:from]
  end

  def image
    payload[:data][:media][:data]
  end

  def payload
    @payload ||= JSON.parse(request.body.read).with_indifferent_access
  end

end
