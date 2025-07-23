class SandboxAutoRepliesController < ApplicationController
  include BasicAuthProtected

  before_action :set_properties
  before_action :set_message
  before_action :set_property

  def index
    @bot_reply = if @message.present?
      AutoReplyIdentifier.new(
        message: @message,
        property: @property
      ).resolve&.reply || "Sorry, I don't have an answer for that"
    end
  end

  private

  def set_properties
    @properties = Property.all
  end

  def set_message
    if params[:message].present?
      @message = Message.new(content: params[:message])
    else
      @message = nil
    end
  end

  def set_property
    if params[:property_id].present?
      @property = Property.find(params[:property_id])
    else
      @property = nil
    end
  end
end
