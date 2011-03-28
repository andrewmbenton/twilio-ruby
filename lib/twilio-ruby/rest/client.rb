module Twilio
  module REST
    class Client
      include Utils

      attr_reader :api_version, :domain, :account_sid, :account, :accounts
    
      def initialize(account_sid, auth_token, api_version='2010-04-01',
                     domain='api.twilio.com', proxy=nil)
        @account_sid = account_sid
        @auth_token = auth_token
        @api_version = api_version
        set_up_connection_to domain, proxy
        set_up_subresources
      end
    
      # Define some helper methods for sending HTTP requests
      [:get, :put, :post, :delete].each do |method|
        method_class = Net::HTTP.const_get method.to_s.capitalize
        define_method method do |uri, *args|
          uri += '.json'
          params = (args[0] && args[0] != {}) ? twilify(args[0]) : nil
          uri += "?#{url_encode(params)}" if params && method == :get
          request = method_class.new uri, 'User-Agent' => 'twilio-ruby/0.3.2'
          request.basic_auth @account_sid, @auth_token
          request.form_data = params if params && [:post, :put].include?(method)
          http_response = @connection.request request
          object = Crack::JSON.parse http_response.body if http_response.body
          raise object['message'] unless http_response.kind_of? Net::HTTPSuccess
          object
        end
      end

      def request(uri, method, params={})
        send method.downcase.to_sym, uri, params
      end
    
      private
    
      def set_up_connection_to(domain, proxy)
        @connection = Net::HTTP.new domain, 443
        @connection.use_ssl = true
        # Don't check the server cert. Ideally this is configurable, in case an
        # app wants to verify that it is actually talking to the real Twilio.
        @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    
      def set_up_subresources
        accounts_uri = "/#{@api_version}/Accounts"
        # Set up a special handle to grab the account.
        @account = Twilio::REST::Account.new "#{accounts_uri}/#{@account_sid}", self
        # Set up the accounts subresource.
        @accounts = Twilio::REST::Accounts.new accounts_uri, self
      end
    
      def url_encode(hash)
        hash.to_a.map {|p| p.map {|e| CGI.escape e.to_s}.join '='}.join '&'
      end
    end
  end
end
