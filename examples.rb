@client = Twilio::Client.new('ACpsodifnpqw', 'ason9234ht9')
@client.accounts #=> a Resources object that acts like a hash, and an array. contains Account objects for each account. does lazy http requests
@account = @client.accounts['ACpsodifnpqw'] #=> an Account object
@accounts = @client.accounts[3,5] #=> an array of 5 Account objects, starting with the fourth (zero indexed)
@account.calls #=> a Resources object that acts like a hash and an array.
@account.calls['CAasd94380wf98hfkl'] #=> a Call object
# this should do what you expect
@account.calls[0,40].each do |c|
  puts c.sid
end

@account.outgoing_caller_ids #=> a Resources object
@account.recordings #=> you get the idea
@account.transcriptions #=> another
@account.sms.messages #=> a little more interesting
@account.conferences['{conferenceSid}'].participants #=> another resources object, or equivalently
@conf = @account.conferences['{conferenceSid}'] #=> a Conference object
@conf.participants #=> the same Resources object as above

@account.incoming_phone_numbers # the most interesting Resources object
@account.incoming_phone_numbers.us #=> another Resources object, that is only good for grabbing...
@account.incoming_phone_numbers.us.local(params={}) #=> a Resources object containing multiple IncomingPhoneNumber resources

# we can "bootstrap" directly into our account object like so...
@same_account = Twilio::Account.new({:auth_sid => 'ACpsodifnpqw', :auth_token => 'ason9234ht9'})

# that is just a particular case of a general rule when instantiating subclasses of the Twilio module...
# the following creates a Call object without actually sending an http request. the hash passed in 
# allows you to create a client object implicitly so that the call object may be "posted" to twilio.
@call = Twilio::Call.new('4156582358', '4157791897', 'http://example.com/someurl',
                         {:auth_sid => 'ACpsodifnpqw', :auth_token => 'ason9234ht9'})
# to actually create the call, via http post to twilio, we do
@call.post # maybe @call.post! is better?

# alternatively we could have created the same exact call via chaining, like so
@call2 = account.calls.create('4156582358', '4157791897', 'http://example.com/someurl')
@call2.post

# the above named parameter implicit client creation works for any subresource of account that is
# creatable (i.e. accepts http post). right now to post to a sub-subresource, like when muting a
# conference participant, the chaining method must be used since an extra piece of information
# (conference sid) is required. although that could be an additional named parameter...

# detailed usage examples to follow:
