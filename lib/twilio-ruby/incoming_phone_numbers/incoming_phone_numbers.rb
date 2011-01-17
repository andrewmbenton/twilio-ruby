module Twilio
  class IncomingPhoneNumbers < ListResource
    def buy(phone_number)
      create :phone_number => phone_number
    end
  end
end
