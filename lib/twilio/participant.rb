module Twilio
  class Participant
    include Twilio::Utils
    
    FIXED_ATTRIBUTES = [:call_sid, :conference_sid, :account_sid, :muted,
      :start_conference_on_enter, :end_conference_on_exit, :date_created, :date_updated]
    MODIFICATION_ATTRIBUTES = [:muted]
    
    attr_reader *FIXED_ATTRIBUTES
    attr_accessor *MODIFICATION_ATTRIBUTES
    
    def initialize(params={})
      FIXED_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      MODIFICATION_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]} if @call_sid
      
      @parent_uri = params[:base_uri]
      
      if params[:client]
        @client = params[:client]
      elsif params[:auth_sid] && params[:auth_token]
        @client = Twilio::Client.new params[:auth_sid], params[:auth_token]
      end
    end
    
    def uri
      @parent_uri + (@call_sid ? "/#{@call_sid}" : '')
    end
    
    def post!
      raise ArgumentError unless @client && @call_sid
      response = @client.post uri, hash_up_attributes
      if response['TwilioResponse']['RestException']
        # TODO handle exception
      else
        # TODO do this right, checking for the appropriate response
        response['TwilioResponse']['Participant'].each do |param, value|
          instance_variable_set "@#{detwilify(param)}", value
        end
      end
      self
    end
    
    # TODO handle delete? return object, with @deleted = true?
    def delete!
      raise ArgumentError unless @client && @call_sid
      response = @client.delete uri
      if response['TwilioResponse']['RestException']
        # TODO handle exception
      end
      self
    end
    
    private
    
    def hash_up_attributes
      Hash[*MODIFICATION_ATTRIBUTES.map {|a| [twilify(a), instance_variable_get("@#{a.to_s}")]}.flatten]
    end
  end
end
