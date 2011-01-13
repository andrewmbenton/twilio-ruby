module Twilio
  class InstanceResource
    include Utils

    def initialize(uri, client, params={})
      @uri, @client = uri, client
      set_up_properties_from params
    end

    def update(params={})
      raise "Can't update a resource without a Twilio::Client" unless @client
      response = @client.put(@uri, params)
      set_up_properties_from response
      self
    end

    def method_missing(method, *args)
      super if @updated == true
      response = @client.get(@uri)
      set_up_properties_from response
      self.send method, *args
    end

    protected

    def set_up_properties_from(hash)
      hash.each do |p,v|
        property = detwilify p
        unless ['uri', 'client', 'updated'].include? property
          instance_variable_set("@#{property}", v)
        end
        make_available property.to_sym
      end
      @updated = true unless hash.keys.empty?
    end

    def instance_resource(*resources)
      resources.each do |r|
        resource = twilify r
        instance_variable_set("@#{r}",
          Twilio.const_get(resource).new("#{@uri}/#{resource}", @client))
      end
      self.class.instance_eval {attr_reader *resources}
    end

    def list_resource(*resources)
      resources.each do |r|
        relative_uri = r == :sms_messages ? 'SMS/Messages' : twilify(r)
        instance_variable_set("@#{r}",
          Twilio::ListResource.new(r, "#{@uri}/#{relative_uri}", @client))
      end
      self.class.instance_eval {attr_reader *resources}
    end

    def make_available(*attributes)
      attributes.each do |attr|
        self.class.instance_eval do
          define_method attr do
            if instance_variable_get("@#{attr}") || @updated
              instance_variable_get "@#{attr}"
            else
              method_missing attr
            end
          end
        end
      end
    end

  end
end
