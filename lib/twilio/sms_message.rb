module Twilio
  class SmsMessage
    include Twilio::Utils
    
    FIXED_ATTRIBUTES = [:sid, :account_sid, :date_sent, :status,
                        :flags, :date_created, :date_updated]
    CREATION_ATTRIBUTES = [:from, :to, :body, :status_callback]
    
    attr_reader *FIXED_ATTRIBUTES
    attr_accessor *CREATION_ATTRIBUTES
    
    def initialize(params={})
      FIXED_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      CREATION_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      @parent_uri = params[:base_uri]
      
      if params[:client]
        @client = params[:client]
      elsif params[:auth_sid] && params[:auth_token]
        @client = Twilio::Client.new params[:auth_sid], params[:auth_token]
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
        puts response['TwilioResponse']['RestException']
      else
        response['TwilioResponse']['SMSMessage'].each do |param, value|
          instance_variable_set "@#{detwilify(param)}", value
        end
      end
      self
    end
    
    private
    
    def hash_up_attributes
      Hash[*CREATION_ATTRIBUTES.map {|a| [twilify(a), instance_variable_get("@#{a.to_s}")]}.flatten]
    end
  end
end
