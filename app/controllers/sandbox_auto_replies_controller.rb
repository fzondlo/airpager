class SandboxAutoRepliesController < ApplicationController
  def index
    @message = params[:message]

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
      You are a helpful airbnb co-host. Here are predefined auto replies:

      #{auto_replies.map { |auto_reply| "- If user says something like: \"#{auto_reply.trigger}\", reply with: \"#{auto_reply.reply}\"" }.join("\n")}

      If none of the triggers match, say: "Sorry, I don't have an answer for that."
    PROMPT
  end

  def auto_replies
    @auto_replies ||= AutoReply.all
  end
end
