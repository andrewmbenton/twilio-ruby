module Twilio
  class SmsMessages < ListResource
    def send(from, to, body)
      create :from => from, :to => to, :body => body
    end
  end
end
