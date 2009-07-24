require File.dirname(__FILE__) + '/../lib/watirloo'
require 'stringio'
require 'spec/autorun'

def testfile(filename)
  path = File.expand_path(File.dirname(__FILE__))
  uri = "file://#{path}/html/" + filename
  return uri
end


