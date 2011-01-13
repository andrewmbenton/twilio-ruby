require 'twilio-ruby'
require 'fakeweb'

describe Twilio::Client do
  before :all do
    FakeWeb.register_uri(:any, %r/http:\/\/api.twilio.com\//, :body => '{"message": "You tried to reach Twilio"}')
  end

  it 'should set up a Twilio::Client' do
    twilio = Twilio::Client.new('someSid', 'someToken', 'api-version')
    twilio.account_sid.should == 'someSid'
    twilio.instance_variable_get('@auth_token').should == 'someToken'
    twilio.api_version.should == 'api-version'
  end
  
  it 'should set up the proper default http ssl connection' do
    twilio = Twilio::Client.new('someSid', 'someToken')
    twilio.instance_variable_get('@connection').address.should == 'api.twilio.com'
    twilio.instance_variable_get('@connection').port.should == 443
    twilio.instance_variable_get('@connection').use_ssl?.should == true
  end
  
  it 'should set up the proper http ssl connection when a different domain is given' do
    twilio = Twilio::Client.new('someSid', 'someToken', '2008-08-01', 'api.faketwilio.com')
    twilio.instance_variable_get('@connection').address.should == 'api.faketwilio.com'
    twilio.instance_variable_get('@connection').port.should == 443
    twilio.instance_variable_get('@connection').use_ssl?.should == true
  end

  it 'should set up an accounts resources object' do
    twilio = Twilio::Client.new('someSid', 'someToken')
    twilio.respond_to?(:accounts).should == true
    twilio.accounts.instance_variable_get('@uri').should == '/2010-04-01/Accounts'
  end

  it 'should set up an account object with the given sid' do
    twilio = Twilio::Client.new('someSid', 'someToken')
    twilio.respond_to?(:account).should == true
    twilio.account.instance_variable_get('@uri').should == '/2010-04-01/Accounts/someSid'
  end

  it 'should convert all parameter names to Twilio-style names' do
    twilio = Twilio::Client.new('someSid', 'someToken')
    untwilified = {:sms_url => 'someUrl', 'voiceFallbackUrl' => 'anotherUrl',
      'Status_callback' => 'yetAnotherUrl'}
    twilified = {:SmsUrl => 'someUrl', :VoiceFallbackUrl => 'anotherUrl',
      :StatusCallback => 'yetAnotherUrl'}
    twilio.instance_eval do
      twilify(untwilified).should == twilified
    end
  end
end

describe Twilio::Account do
  it 'should set up an incoming phone numbers resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:incoming_phone_numbers).should == true
    account.incoming_phone_numbers.instance_variable_get('@uri').should == 'someUri/IncomingPhoneNumbers'
  end

  it 'should set up an available phone numbers resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:available_phone_numbers).should == true
    account.available_phone_numbers.instance_variable_get('@uri').should == 'someUri/AvailablePhoneNumbers'
  end

  it 'should set up an outgoing caller ids resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:outgoing_caller_ids).should == true
    account.outgoing_caller_ids.instance_variable_get('@uri').should == 'someUri/OutgoingCallerIds'
  end

  it 'should set up a calls resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:calls).should == true
    account.calls.instance_variable_get('@uri').should == 'someUri/Calls'
  end

  it 'should set up a conferences resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:conferences).should == true
    account.conferences.instance_variable_get('@uri').should == 'someUri/Conferences'
  end

  it 'should set up a sms messages resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:sms_messages).should == true
    account.sms_messages.instance_variable_get('@uri').should == 'someUri/SMS/Messages'
  end

  it 'should set up a recordings resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:recordings).should == true
    account.recordings.instance_variable_get('@uri').should == 'someUri/Recordings'
  end

  it 'should set up a transcriptions resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:transcriptions).should == true
    account.transcriptions.instance_variable_get('@uri').should == 'someUri/Transcriptions'
  end

  it 'should set up a notifications resources object' do
    account = Twilio::Account.new('someUri', 'someClient')
    account.respond_to?(:notifications).should == true
    account.notifications.instance_variable_get('@uri').should == 'someUri/Notifications'
  end
end

describe Twilio::Call do
  it 'should set up a recordings resources object' do
    call = Twilio::Call.new('someUri', 'someClient')
    call.respond_to?(:recordings).should == true
    call.recordings.instance_variable_get('@uri').should == 'someUri/Recordings'
  end

  it 'should set up a recordings resources object' do
    call = Twilio::Call.new('someUri', 'someClient')
    call.respond_to?(:transcriptions).should == true
    call.transcriptions.instance_variable_get('@uri').should == 'someUri/Transcriptions'
  end
end

describe Twilio::Conference do
  it 'should set up a participants resources object' do
    call = Twilio::Conference.new('someUri', 'someClient')
    call.respond_to?(:participants).should == true
    call.participants.instance_variable_get('@uri').should == 'someUri/Participants'
  end
end

describe Twilio::Recording do
  it 'should set up a transcriptions resources object' do
    call = Twilio::Recording.new('someUri', 'someClient')
    call.respond_to?(:transcriptions).should == true
    call.transcriptions.instance_variable_get('@uri').should == 'someUri/Transcriptions'
  end
end
