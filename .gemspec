spec = Gem::Specification.new do |s|
  s.name = "twilio-ruby"
  s.version = "0.0.2"
  s.author = "Andrew Benton"
  s.email = "andrewmbenton@gmail.com"
  s.description = "A simple library for communicating with the Twilio REST API"
  s.summary = "A simple library for communicating with the Twilio REST API"
  s.homepage = "http://github.com/twilio/twilio-ruby"
  s.platform = Gem::Platform::RUBY
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + ['examples.rb', 'Rakefile']
  s.test_files = Dir['test/**/*.rb']
  s.add_dependency("builder", ">= 3.0.0")
  s.add_dependency("crack", ">= 0.1.8")
end
