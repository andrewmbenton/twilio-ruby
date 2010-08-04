require 'lib/twilio'

describe Twilio::Client do
  it 'should cache the initialization parameters' do
    twilio = Twilio::Client.new 'someSid', 'someToken'
    twilio.instance_variable_get('@sid').should == 'someSid'
    twilio.instance_variable_get('@token').should == 'someToken'
  end
  
  it 'should set up the proper base uri' do
    twilio = Twilio::Client.new 'someSid', 'someToken'
    twilio.instance_variable_get('@this_uri').should == '/2008-08-01'
  end
  
  it 'should set up the correct base uri when a different api version is given' do
    twilio = Twilio::Client.new 'someSid', 'someToken', '2010-01-01'
    twilio.instance_variable_get('@this_uri').should == '/2010-01-01'
  end
  
  it 'should set up the proper default http ssl connection' do
    twilio = Twilio::Client.new 'someSid', 'someToken'
    twilio.instance_variable_get('@connection').address.should == 'api.twilio.com'
    twilio.instance_variable_get('@connection').port.should == 443
    twilio.instance_variable_get('@connection').use_ssl?.should == true
  end
  
  it 'should set up the proper http ssl connection when a different domain is given' do
    twilio = Twilio::Client.new 'someSid', 'someToken', '2008-08-01', 'api.faketwilio.com'
    twilio.instance_variable_get('@connection').address.should == 'api.faketwilio.com'
    twilio.instance_variable_get('@connection').port.should == 443
    twilio.instance_variable_get('@connection').use_ssl?.should == true
  end
  
  
end
