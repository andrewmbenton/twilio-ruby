module Twilio
  module Utils
    def twilify(something)
      if something.is_a? Hash
        Hash[*something.to_a.map {|pair| [twilify(pair[0]).to_sym, pair[1]]}.flatten]
      else
        something.to_s.split('_').map {|s| s.capitalize}.join
      end
    end
    
    def detwilify(something)
      if something.is_a? Hash
        Hash[*something.to_a.map {|pair| [detwilify(pair[0]).to_sym, pair[1]]}.flatten]
      else
        something.to_s.gsub(/[A-Z][a-z]*/) {|s| "_#{s.downcase}"}.gsub(/^_/, '')
      end
    end
  end
end
