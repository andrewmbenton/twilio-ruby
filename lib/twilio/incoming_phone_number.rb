module Twilio
  class IncomingPhoneNumber
    include Twilio::Utils
    
    SUBRESOURCES = []
    FIXED_ATTRIBUTES = [:sid, :account_sid, :phone_number, :date_created, :date_updated]
    MODIFICATION_ATTRIBUTES = [:friendly_name, :url, :method, :voice_fallback_url,
      :voice_fallback_method, :sms_url, :sms_method, :sms_fallback_url,
      :sms_fallback_method, :voice_caller_id_lookup]
    
    attr_reader *SUBRESOURCES
    attr_reader *FIXED_ATTRIBUTES
    attr_accessor *MODIFICATION_ATTRIBUTES
    
    def initialize(params={})
      FIXED_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      MODIFICATION_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]} if @sid
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
      raise ArgumentError unless @client && @sid
      response = @client.post uri, hash_up_attributes
      if response['TwilioResponse']['RestException']
        # TODO handle exception
      else
        response['TwilioResponse']['IncomingPhoneNumber'].each do |param, value|
          instance_variable_set "@#{detwilify(param)}", value
        end
      end
      self
    end
    
    # TODO how to handle delete properly?
    def delete!
      raise ArgumentError unless @client && @sid
      response = @client.delete uri
      if response['TwilioResponse']['RestException']
        # TODO handle exception
        self
      end
      true
    end
    
    private
    
    def hash_up_attributes
      Hash[*MODIFICATION_ATTRIBUTES.map {|a| [twilify(a), instance_variable_get("@#{a.to_s}")]}.flatten]
    end
  end
end
