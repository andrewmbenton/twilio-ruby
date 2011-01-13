module Twilio
  class Recording < InstanceResource
    def initialize(uri, client, params={})
      super uri, client, params
      list_resource :transcriptions
    end
  end
end
