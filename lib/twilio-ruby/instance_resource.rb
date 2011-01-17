module Twilio
  class InstanceResource
    include Utils

    def initialize(uri, client, params={})
      @uri, @client = uri, client
      set_up_properties_from params
    end

    def update(params={})
      raise "Can't update a resource without a Twilio::Client" unless @client
      response = @client.post @uri, params
      set_up_properties_from response
      self
    end

    def delete
      raise "Can't delete a resource without a Twilio::Client" unless @client
      @client.delete @uri
    end

    def method_missing(method, *args)
      super if @updated
      response = @client.get @uri
      set_up_properties_from response
      self.send method, *args
    end

    protected

    def set_up_properties_from(hash)
      eigenclass = class << self; self; end
      hash.each do |p,v|
        property = detwilify p
        unless ['uri', 'client', 'updated'].include? property
          eigenclass.send :define_method, property.to_sym, &lambda {v}
        end
      end
      @updated = !hash.keys.empty?
    end

    def resource(*resources)
      resources.each do |r|
        resource = twilify r
        relative_uri = r == :sms_messages ? 'SMS/Messages' : resource
        instance_variable_set("@#{r}",
          Twilio.const_get(resource).new("#{@uri}/#{relative_uri}", @client))
      end
      self.class.instance_eval {attr_reader *resources}
    end

  end
end
