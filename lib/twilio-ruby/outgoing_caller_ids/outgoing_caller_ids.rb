module Twilio
  class OutgoingCallerIds < ListResource
    def add(phone_number)
      create :phone_number => phone_number
    end
  end
end
