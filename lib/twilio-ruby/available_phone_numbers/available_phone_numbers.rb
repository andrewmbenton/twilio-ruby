module Twilio
  class AvailablePhoneNumbers < ListResource
    def initialize(uri, client)
      @resource_name = 'countries'
      @instance_class = Twilio.const_get 'Country'
      @uri, @client = uri, client
    end
  end
end
