module TwilioApi
  class Gateway
    attr_reader :account_sid, :auth_token

    def initialize(account_sid, auth_token)
      @account_sid = account_sid
      @auth_token = auth_token
    end

    def create_call(phone_number)
      client.calls.create(
        from: SystemConfig::TWILIO_PHONE_NUMBER,
        to: phone_number,
        url: "https://handler.twilio.com/twiml/EH92d57a98fa015b948b857f3daaa7dc57"
      )
    end

    private

    def client
      @client ||= Twilio::REST::Client.new(account_sid, auth_token)
    end
  end
end
