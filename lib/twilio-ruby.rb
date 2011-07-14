TWILIO_RUBY_ROOT = File.expand_path(File.dirname(__FILE__))

require 'net/http'
require 'net/https'
require 'builder'
require 'crack'
require 'cgi'
require 'openssl'
require 'base64'


require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/errors"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/utils"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/list_resource"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/instance_resource"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/sandbox/sandbox"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/accounts/account"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/accounts/accounts"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/calls/call"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/calls/calls"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/sms/sms"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/sms/message"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/sms/messages"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/sms/short_code"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/sms/short_codes"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/applications/application"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/applications/applications"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/outgoing_caller_ids/outgoing_caller_id"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/outgoing_caller_ids/outgoing_caller_ids"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/incoming_phone_numbers/incoming_phone_number"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/incoming_phone_numbers/incoming_phone_numbers"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/available_phone_numbers/available_phone_number"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/available_phone_numbers/available_phone_numbers"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/available_phone_numbers/country"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/available_phone_numbers/local"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/available_phone_numbers/toll_free"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/conferences/conference"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/conferences/conferences"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/conferences/participant"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/conferences/participants"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/recordings/recording"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/recordings/recordings"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/transcriptions/transcription"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/transcriptions/transcriptions"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/notifications/notification"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/notifications/notifications"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/rest/client"
require "#{TWILIO_RUBY_ROOT}/twilio-ruby/twiml/response"
