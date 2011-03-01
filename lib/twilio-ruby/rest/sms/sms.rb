module Twilio
  module REST
    class Sms < InstanceResource
      def initialize(uri, client, params={})
        super uri, client, params
        resource :messages
      end
    end
  end
end
