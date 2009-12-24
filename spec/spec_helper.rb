$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'watirloo'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|

end

module WatirlooSpecHelper
  def testfile(filename)
    path = File.expand_path(File.dirname(__FILE__))
    uri = "file://#{path}/html/" + filename
    return uri
  end
end

include WatirlooSpecHelper

