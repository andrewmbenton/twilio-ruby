require File.dirname(__FILE__) + '/../lib/twilio'

twilio = Twilio::Client.new('AC2ae18c3d1a42ddb2eea67f8bef081728', 'd15433e698105a045e9d3cd84ed0c909')
puts twilio.get('/')


