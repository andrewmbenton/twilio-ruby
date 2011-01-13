module Twilio
  class ListResource
    include Utils

    def initialize(kind, uri, client)
      @kind = kind.to_s
      instance_resource_name = @kind.split('_').map {|s| s.capitalize}.join.chop
      @instance_class = Twilio.const_get(instance_resource_name)
      @uri, @client = uri, client
    end
    
    # Grab a list of this kind of resource and return it as an array.
    def list(params={})
      raise "Can't get a resource list without a Twilio::Client" unless @client
      resources = @client.get(@uri, params)[@kind]
      resources.map do |resource|
        @instance_class.new("#{@uri}/#{resource['sid']}", @client, resource)
      end
    end

    # Return an empty instance resource object with the proper URI.
    def get(sid)
      @instance_class.new("#{@uri}/#{sid}", @client)
    end
    
    # Return a newly created resource.
    def create(params={})
      raise "Can't create a resource without a Twilio::Client" unless @client
      response = @client.post(@uri, params)
      @instance_class.new("#{@uri}/#{response['sid']}", @client, response)
    end
  end
end
