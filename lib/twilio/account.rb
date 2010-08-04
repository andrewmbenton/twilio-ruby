module Twilio
  class Account
    include Twilio::Utils
    
    SUBRESOURCES = [:calls, :outgoing_caller_ids, :incoming_phone_numbers, :conferences,
                    :sms_messages, :recordings, :transcriptions, :notifications]
    FIXED_ATTRIBUTES = [:sid, :status, :date_created, :date_updated]
    MODIFICATION_ATTRIBUTES = [:friendly_name]
    
    attr_reader *SUBRESOURCES
    attr_reader *FIXED_ATTRIBUTES
    attr_accessor *MODIFICATION_ATTRIBUTES
    
    def initialize(params={})
      FIXED_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      MODIFICATION_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]} if @sid
      
      @parent_uri = '/Accounts'
      
      if params[:client]
        @client = params[:client]
      elsif params[:auth_sid] && params[:auth_token]
        @client = Twilio::Client.new params[:auth_sid], params[:auth_token]
      end
      
      # If this is an actual resource living at twilio, set up all the subresources objects
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
        response['TwilioResponse']['Account'].each do |param, value|
          instance_variable_set "@#{detwilify(param)}", value
        end
      end
      self
    end
    
    private
    
    def hash_up_attributes
      Hash[*MODIFICATION_ATTRIBUTES.map {|a| [twilify(a), instance_variable_get("@#{a.to_s}")]}.flatten]
    end
  end
end
