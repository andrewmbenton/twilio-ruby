# examples version 3

@account_sid = 'AC043dcf9844e04758bc3a36a84c29761'
@auth_token = '62ea81de3a5b414154eb263595357c69'
# set up a client, without any http requests
@client = Twilio::Client.new(@account_sid, @auth_token, '2010-04-01', 'api.twilio.com')

################ ACCOUNTS ################

# grab an account instance resource (single http req)
@account = @client.accounts.get(@account_sid)
puts @account.friendly_name
@account.subresource_uris.each {|uri| puts uri}

# update an account's friendly name (only one http request, for the POST)
@client.accounts.get(@account_sid).update({:friendly_name => 'A Fabulous Friendly Name'})

################ CALLS ################

# grab an account handle (account_sid is inferred from the client auth credentials)
@account = @client.account # this object has no actual account properties like the one above

# print a list of calls (all parameters optional, single http req)
@account.calls.list({:page => 0, :page_size => 1000, :start_time => '2010-09-01'}).each do |call|
  puts call.sid
end

# get a particular call and list its recordings (one http req, for each())
@account.calls.get('CAXXXXXXX').recordings.list().each do {|n| puts n.message_text}

# make a new outgoing call (this is the same type of object we get from calls.get, except this has attributes)
@call = @account.calls.create({:from => '+14159341234', :to => '+18004567890', :url => 'http://myapp.com/call-handler'})

# cancel the call if not already in progress (single http request)
@account.calls.get(@call.sid).update({:status => 'canceled'}) # formerly @call.cancel
# OR equivalently (single http request)
@call.update({:status => 'canceled'})

# redirect and then terminate a call (each one http request)
@account.calls.get('CA386025c9bf5d6052a1d1ea42b4d16662').update({:url => 'http://myapp.com/call-redirect'}) #formerly @call.redirect('http://myapp.com/call-redirect')
@account.calls.get('CA386025c9bf5d6052a1d1ea42b4d16662').update({:status => 'completed'}) # formerly @call.hangup

################ SMS MESSAGES ################

# print a list of sms messages
@account.sms_messages.list({:date_sent => '2010-09-01'}).each do |sms|
  puts sms.body
end

# print a particular sms message
puts @account.sms_messages.get('SMXXXXXXXX').body

# send an sms
@account.sms_messages.create('+1415934123', '+16105557069', 'Hey there!')

################ PHONE NUMBERS ################

# get a list of supported country codes
@account.available_phone_numbers.list()

# print some available numbers (only one http request)
@numbers = @account.available_phone_numbers.get('US').local.list({:contains => 'AWESOME'})
@numbers.each {|num| puts num.phone_number}

# buy the first one
@account.incoming_phone_numbers.create(@numbers[0].phone_number)
# shortcut?: @account.incoming_phone_numbers.create(@numbers[0])

# update an existing phone number
@account.incoming_phone_numbers.get('PNdba508c5616a7f5e141789f44f022cc3').update({:voice_url => 'http://myapp.com/voice'})

################ CONFERENCES  ################

# get a particular conference's participant list object and stash it (should be zero http requests)
@participants = @account.conferences.get('CFbbe46ff1274e283f7e3ac1df0072ab39').participants.list()

# list participants (http request here)
@participants.each do {|p| puts p}

# update a conference participant
@participants.get('CA386025c9bf5d6052a1d1ea42b4d16662').update({:muted => 'true'})

# or, as long as we're lazy loading, this would only incur one http req
@account.conferences.get('CFbbe46ff1274e283f7e3ac1df0072ab39').participants.get('CA386025c9bf5d6052a1d1ea42b4d16662').update({:muted => 'true'})
