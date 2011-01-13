module Twilio
  class Call < InstanceResource
    def initialize(uri, client, params={})
      super uri, client, params
      list_resource :recordings, :transcriptions
    end

    def redirect_to(url)
      update :url => url
    end

    def cancel
      update :status => 'canceled'
    end

    def hangup
      update :status => 'completed'
    end
  end
end
