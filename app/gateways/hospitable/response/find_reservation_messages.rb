module Hospitable
  class Response
    class FindReservationMessages < Response
      def select_conversation_messages(conversation_id)
        messages = body['data']

        # Filter messages that are not from this conversation_id
        messages.select { |message| message['conversation_id'] == conversation_id }
      end
    end
  end
end


# conv id: 83797e96-9ff6-4cbc-a986-9ef5dd3ca4cd
# res id: ba7749b2-1b12-4c08-8d15-a7eb01d1b844
