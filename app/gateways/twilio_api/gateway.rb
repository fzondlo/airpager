module TwilioApi
  class Gateway
    attr_reader :account_sid, :auth_token

    def initialize(account_sid, auth_token)
      @account_sid = account_sid
      @auth_token = auth_token
    end

    def create_call(phone_number: "+573170949147", url: "http://demo.twilio.com/docs/classic.mp3")
      client.calls.create(
        from: SystemConfig::TWILIO_PHONE_NUMBER,
        to: phone_number,
        url: url
      )
    end

    private

    def client
      @client ||= Twilio::REST::Client.new(account_sid, auth_token)
    end
  end
end
