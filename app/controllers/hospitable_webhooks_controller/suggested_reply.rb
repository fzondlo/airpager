class HospitableWebhooksController
  class SuggestedReply
    include Task::Mapping

    attr_reader :message

    def initialize(message)
      @message = message
    end

    def log
      Waapi.gateway.send_message(body, LOGGING_WA_GROUP)

      if auto_reply.present? && !auto_reply_already_used?
        AutoReplyUsage.create(
          conversation_id: message.conversation_id,
          auto_reply: auto_reply
        )
      end
    end

    private

    def body
      unless auto_reply.present?
        return <<~TEXT
          New Message from #{message.sender_full_name}:
          #{message.content}

          -----

          Suggested Reply:
          Sorry, I don't have an answer for that.
        TEXT
      end


      if auto_reply_already_used?
        return <<~TEXT
          New Message from #{message.sender_full_name}:
          #{message.content}

          -----

          Suggested Reply:
          #{auto_reply.reply}

          -----

          Debug:
          This suggested reply has already been used in the conversation, skipping ...
        TEXT
      end

      <<~TEXT
        New Message from #{message.sender_full_name}:
        #{message.content}

        -----

        Suggested Reply:
        #{auto_reply.reply}
      TEXT
    end

    def property_id
      @property_id ||= PropertyIdentifier.new(message).resolve&.id
    end

    def auto_reply
      return unless property_id.present?

      @auto_reply ||= AutoReplyIdentifier.new(
        message: message.content,
        property_id: property_id,
        live_mode: true
      ).resolve
    end

    def auto_reply_used_ids
      @auto_reply_used_ids ||= AutoReplyUsage.where(conversation_id: message.conversation_id).pluck(:auto_reply_id)
    end

    def auto_reply_already_used?
      auto_reply.id.in?(auto_reply_used_ids)
    end
  end
end
