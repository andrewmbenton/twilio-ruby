require 'net/http'
require 'net/https'
require 'builder'
require 'crack'
require 'cgi'
require 'openssl'
require 'base64'


require 'twilio-ruby/rest/utils'
require 'twilio-ruby/rest/list_resource'
require 'twilio-ruby/rest/instance_resource'
Dir.glob('twilio-ruby/rest/*/*.rb').each {|f| require f}
require 'twilio-ruby/rest/client'
require 'twilio-ruby/twiml/response'
