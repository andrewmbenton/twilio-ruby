module Twilio
  class Account < InstanceResource
    def initialize(uri, client, params={})
      super uri, client, params
      instance_resource :sandbox
      list_resource :available_phone_numbers, :incoming_phone_numbers, :calls,
        :outgoing_caller_ids, :conferences, :sms_messages, :recordings,
        :transcriptions, :notifications
    end
  end
end
