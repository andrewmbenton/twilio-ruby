module Twilio
  module REST
    class Messages < ListResource
      def send(from, to, body)
        create :from => from, :to => to, :body => body
      end
    end
  end
end
