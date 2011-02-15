module Twilio
  module REST
    module Utils

      def twilify(something)
        if something.is_a? Hash
          Hash[*something.to_a.map {|a| [twilify(a[0]).to_sym, a[1]]}.flatten]
        else
          something.to_s.split('_').map do |s|
            [s[0,1].capitalize, s[1..-1]].join
          end.join
        end
      end

      def detwilify(something)
        if something.is_a? Hash
          Hash[*something.to_a.map {|pair| [detwilify(pair[0]).to_sym, pair[1]]}.flatten]
        else
          something.to_s.gsub(/[A-Z][a-z]*/) {|s| "_#{s.downcase}"}.gsub(/^_/, '')
        end
      end

      def self.validate(auth_token, signature, url, params={})
        data = url + params.sort.to_s
        digest = OpenSSL::Digest::Digest.new('sha1')
        expected = Base64.encode64(OpenSSL::HMAC.digest(digest, auth_token, data)).strip
        return expected == signature
      end

    end
  end
end
