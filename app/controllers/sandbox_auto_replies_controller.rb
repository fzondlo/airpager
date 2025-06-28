class SandboxAutoRepliesController < ApplicationController
  include BasicAuthProtected

  before_action :set_properties
  before_action :set_message
  before_action :set_property_id

  def index
    if @message.present?
      response = OpenAi.gateway.auto_reply(system_prompt, @message)

      if response.success?
        @bot_reply = response.answer
      else
        @bot_reply = 'Error: Unable to connect to OpenAI ...'
      end
    end
  end

  private

  def system_prompt
    <<~PROMPT
      You are a helpful Airbnb co-host assistant. Below is a list of predefined auto replies based on common guest questions or phrases.

      Your task is to:
      - Interpret the guest's message.
      - If the meaning closely matches one of the triggers below, respond with the corresponding reply.
      - If the message does not match the meaning of any trigger, or if the list is empty, respond **exactly** with: "Sorry, I don't have an answer for that."

      Only respond with replies listed below. Do not generate your own reply.

      Predefined replies:
      #{auto_replies.map { |auto_reply| "- If the guest says something like: \"#{auto_reply.trigger}\", reply with: \"#{auto_reply.reply}\"" }.join("\n")}

      Do not invent new answers. Only use the replies provided or return the fallback message as instructed.
    PROMPT
  end

  def auto_replies
    return AutoReply.none unless @property_id.present?

    AutoReply.joins(:properties).where(properties: { id: @property_id })
  end

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
