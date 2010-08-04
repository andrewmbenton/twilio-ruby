module Twilio
  class Resources
    include Twilio::Utils
    
    def initialize(pluralized_name, client, parent_uri=nil)
      @pluralized_name = pluralized_name.to_s.split('_').map {|s| s.capitalize}.join
      @resources = {}
      @this_uri = "#{parent_uri}/#{@pluralized_name}"
      @client = client
    end
    
    def [](sid_or_start, length=nil)
      if length
        # TODO implement this. return a range. may need several http requests
      else
        if sid_or_start.is_a? Fixnum
          # TODO implement this. return a particular resource based on its numerical ranking
        else
          response = @client.get("#{@this_uri}/#{sid_or_start}")
          if response['TwilioResponse']['RestException']
            # TODO handle exception
            puts response
          else
            params = Hash[*response['TwilioResponse'][@pluralized_name.chop].to_a.map {|pair| [detwilify(pair[0]).to_sym, pair[1]]}.flatten]
            
            Twilio.const_get(@pluralized_name.chop).new(params.merge({:client => @client, :base_uri => @this_uri}))
          end
        end
      end
    end
    
    # Return a newly created resource, ready to post to twilio
    def create(params={})
      Twilio.const_get(@pluralized_name.chop).new(params.merge({:client => @client, :base_uri => @this_uri}))
    end
  end
end
