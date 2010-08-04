module Twilio
  class OutgoingCallerId
    include Twilio::Utils
    
    SUBRESOURCES = []
    FIXED_ATTRIBUTES = [:sid, :account_sid, :validation_code, :date_created, :date_updated]
    CREATION_ATTRIBUTES = [:phone_number, :friendly_name, :call_delay]
    MODIFICATION_ATTRIBUTES = [:friendly_name]
    
    attr_reader *SUBRESOURCES
    attr_reader *FIXED_ATTRIBUTES
    attr_accessor *CREATION_ATTRIBUTES
    attr_accessor *MODIFICATION_ATTRIBUTES
    
    def initialize(params={})
      FIXED_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      @sid ? MODIFICATION_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]} \
           : CREATION_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      @parent_uri = params[:base_uri]
      
      if params[:client]
        @client = params[:client]
      elsif params[:auth_sid] && params[:auth_token]
        @client = Twilio::Client.new params[:auth_sid], params[:auth_token]
      end
      
      # set up subresources objects if this is an actual resource living at twilio or we have a client 
      if @client || @sid
        SUBRESOURCES.each do |kind|
          instance_variable_set "@#{kind}", Twilio::Resources.new(kind, @client, uri)
        end
      end
    end
    
    def uri
      @parent_uri + (@sid ? "/#{@sid}" : '')
    end
    
    def post!
      raise ArgumentError unless @client
      response = @client.post uri, hash_up_attributes
      if response['TwilioResponse']['RestException']
        # TODO handle exception
      else
        # TODO do this right, checking for the appropriate response
        response['TwilioResponse']['ValidationRequest'].each do |param, value|
          instance_variable_set "@#{detwilify(param)}", value
        end
      end
      self
    end
    
    # TODO handle delete? return object, with @deleted = true?
    def delete!
      raise ArgumentError unless @client && @sid
      response = @client.delete uri
      if response['TwilioResponse']['RestException']
        # TODO handle exception
      else
        self
      end
    end
    
    private
    
    def hash_up_attributes
      if @sid
        Hash[*MODIFICATION_ATTRIBUTES.map {|a| [twilify(a), instance_variable_get("@#{a.to_s}")]}.flatten]
      else
        Hash[*CREATION_ATTRIBUTES.map {|a| [twilify(a), instance_variable_get("@#{a.to_s}")]}.flatten]
      end
    end
  end
end
