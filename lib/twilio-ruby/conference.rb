module Twilio
  class Conference < InstanceResource
    def initialize(uri, client, params={})
      super uri, client, params
      list_resource :participants
    end
  end
end
