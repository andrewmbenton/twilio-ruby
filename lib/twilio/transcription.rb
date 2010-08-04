module Twilio
  class Transcription
    include Twilio::Utils
    
    FIXED_ATTRIBUTES = [:sid, :recording_sid, :account_sid, :duration, :status,
      :transcription_text, :price, :date_created, :date_updated]
    
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
  end
end
