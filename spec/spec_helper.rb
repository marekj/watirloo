$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'watirloo'
require 'spec'
require 'spec/autorun'

module WatirlooSpecHelper
  def testfile(filename)
    path = File.expand_path(File.dirname(__FILE__))
    uri = "file://#{path}/html/" + filename
    return uri
  end
end

Spec::Runner.configure do |runner|
  runner.include WatirlooSpecHelper
end

#Make it run on Firefox
#Watir::Browser.default='firefox'
#Watir::Browser.new
#Watirloo::Browsers.target = :firefox
