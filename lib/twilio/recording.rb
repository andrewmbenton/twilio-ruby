module Twilio
  class Recording
    include Twilio::Utils
    
    SUBRESOURCES = [:transcriptions]
    FIXED_ATTRIBUTES = [:sid, :call_sid, :account_sid, :duration, :date_created, :date_updated]
    
    attr_reader *FIXED_ATTRIBUTES
    
    def initialize(params={})
      FIXED_ATTRIBUTES.each {|a| instance_variable_set "@#{a.to_s}", params[a]}
      
      @parent_uri = params[:base_uri]
      
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
