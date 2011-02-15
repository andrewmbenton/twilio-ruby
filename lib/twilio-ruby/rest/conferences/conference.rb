module Twilio
  module REST
    class Conference < InstanceResource
      def initialize(uri, client, params={})
        super uri, client, params
        resource :participants
      end
    end
  end
end
