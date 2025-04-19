class HospitableWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if handler.present?
      handler.new(payload).perform
    end

    render json: { message: :success }
  end

  private

  def payload
    @payload ||= JSON.parse(request.body.read)
  end

  def handler
    @handler ||= handler_for(
      payload["action"]
    )
  end

  def handler_for(action)
    {
      "message.created" => MessageCreatedHandler
    }[action]
  end
end
