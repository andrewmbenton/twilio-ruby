module Twilio
  class Call < InstanceResource
    def initialize(uri, client, params={})
      super uri, client, params
      list_resource :recordings, :transcriptions
    end
  end
end
