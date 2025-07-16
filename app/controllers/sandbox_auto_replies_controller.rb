class SandboxAutoRepliesController < ApplicationController
  include BasicAuthProtected

  before_action :set_properties
  before_action :set_message
  before_action :set_property_id

  def index
    @bot_reply = if @message.present?
      AutoReplyIdentifier.new(
        message: @message,
        property_id: @property_id
      ).resolve&.reply || "Sorry, I don't have an answer for that"
    end
  end

  private

  def set_properties
    @properties = Property.all
  end

  def set_message
    @message = params[:message]
  end

  def set_property_id
    @property_id = params[:property_id]
  end
end
