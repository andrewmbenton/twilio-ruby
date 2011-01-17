module Twilio
  class Country < InstanceResource
    def initialize(uri, client, params={})
      super uri, client, params
      resource :local, :toll_free
    end
  end
end
