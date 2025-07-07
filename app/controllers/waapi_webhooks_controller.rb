class WaapiWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  include Task::Mapping

  def create
    return if !subscribed_to_group? || !contains_image?
    ProcessReceiptWorker.perform_async(WHATSAPP_FACTURA_GROUPS[group_id], group_id, image)
  end

  private

  def contains_image?
    payload[:data][:media][:mimetype] == "image/jpeg"
  end

  def subscribed_to_group?
    !!WHATSAPP_FACTURA_GROUPS[group_id]
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
