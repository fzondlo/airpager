class HospitableWebhooksController
  class SuggestedReply
    include SystemConfig

    attr_reader :message

    def initialize(message)
      @message = message
    end

    def log
      unless auto_reply.present?
        return log_auto_reply_not_found
      end

      if auto_reply_already_used?
        return log_auto_reply_already_used
      end

      unless auto_reply.live_enabled?
        return log_auto_reply_sandbox_mode
      end

      log_auto_reply_live_mode
    end

    private

    def log_auto_reply_not_found
      body = <<~TEXT
        New Message from #{message.sender_full_name}:
        #{message.content}

        -----

        Suggested Reply:
        Sorry, I don't have an answer for that.

        -----

        Debug:
        Suggested reply not found.
      TEXT

      Waapi.gateway.send_message(body, LOGGING_WA_GROUP)
    end

    def log_auto_reply_already_used
      body = <<~TEXT
        New Message from #{message.sender_full_name}:
        #{message.content}

        -----

        Suggested Reply:
        ##{auto_reply.id} – #{auto_reply.reply}

        -----

        Debug:
        This suggested reply has already been used in the conversation, skipping ...
      TEXT

      Waapi.gateway.send_message(body, LOGGING_WA_GROUP)
    end

    def log_auto_reply_sandbox_mode
      body = <<~TEXT
        New Message from #{message.sender_full_name}:
        #{message.content}

        -----

        Suggested Reply:
        ##{auto_reply.id} – #{auto_reply.reply}

        -----

        Debug:
        This suggested reply would not have been sent (not live enabled)
      TEXT

      AutoReplyUsage.create(
        conversation_id: message.conversation_id,
        reservation_id: message.reservation_id,
        usage_type: "sandbox",
        message_trigger_id: message.id,
        suggested_reply: auto_reply.reply,
        auto_reply: auto_reply
      )

      Waapi.gateway.send_message(body, LOGGING_WA_GROUP)
    end

    def log_auto_reply_live_mode
      body = <<~TEXT
        New Message from #{message.sender_full_name}:
        #{message.content}

        -----

        Suggested Reply:
        ##{auto_reply.id} – #{auto_reply.reply}

        -----

        Debug:
        This suggested reply would have been sent (live enabled)
      TEXT

      AutoReplyUsage.create(
        conversation_id: message.conversation_id,
        reservation_id: message.reservation_id,
        usage_type: "live",
        message_trigger_id: message.id,
        suggested_reply: auto_reply.reply,
        auto_reply: auto_reply
      )

      Waapi.gateway.send_message(body, LOGGING_WA_GROUP)
    end

    def property
      @property ||= PropertyIdentifier.new(message).resolve
    end

    def auto_reply
      return unless property.present?

      @auto_reply ||= AutoReplyIdentifier.new(
        message: message,
        property: property
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
