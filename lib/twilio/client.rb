module Twilio
  class Client
    attr_reader :auth_sid, :base_uri, :accounts
    
    def initialize(auth_sid, auth_token, api_version='2010-04-01', domain='api.twilio.com')
      @auth_sid = auth_sid
      @auth_token = auth_token
      @base_uri = "/#{api_version}"
      set_up_connection domain
      @accounts = Twilio::Resources.new :accounts, self # Set up the accounts subresources object
    end
    
    # Define some helper methods for sending HTTP requests
    [:get, :put, :post, :delete].each do |method|
      request_class = Net::HTTP.const_get(method.to_s.capitalize)
      define_method method do |uri, *args|
        url = method == :get ? "#{@base_uri}#{uri}?#{url_encode(args[0])}" : "#{@base_uri}#{uri}"
        request = request_class.new(url)
        request.basic_auth @auth_sid, @auth_token
        request.form_data = args[0] if [:post, :put].include? method
        puts "DEBUG: Request Path ==>   "+request.path
        puts "DEBUG: Request Body ==>   "+request.body if request.body
        Crack::XML.parse @connection.request(request).body
      end
    end
    
    private
    
    def set_up_connection(domain)
      @connection = Net::HTTP.new(domain, 443)
      @connection.use_ssl = true
      # don't check the server cert. ideally this is configurable, in case an app
      # wants to verify that it is actually talking to the real twilio
      @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    def url_encode(hash)
      hash.to_a.map {|pair| pair.map {|e| CGI.escape e.to_s}.join '='}.join '&'
    end
  end
end
