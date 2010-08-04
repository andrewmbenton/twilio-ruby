module Twilio
  class Notification
    include Twilio::Utils
    
    FIXED_ATTRIBUTES = [:sid, :call_sid, :account_sid, :log, :error_code,
      :more_info, :message_text, :message_date, :request_url, :request_method,
      :request_variables, :response_headers, :response_body, :date_created,
      :date_updated]
    
    attr_reader *FIXED_ATTRIBUTES
    
    def initialize(params={})
      FIXED_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      
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
    
    # TODO handle delete? return object, with @deleted = true?
    def delete!
      raise ArgumentError unless @client && @sid
      response = @client.delete uri
      if response['TwilioResponse']['RestException']
        # TODO handle exception
      end
      self
    end
  end
end
