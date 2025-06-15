class HospitableWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  HANDLERS = {
    "message.created" => MessageCreatedHandler,
    "reservation.created" => ReservationCreatedHandler,
    "reservation.updated" => ReservationUpdatedHandler
  }

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
    @handler ||= HANDLERS[payload["action"]]
  end
end
