require File.dirname(__FILE__) + '/../../lib/watirloo/firewatir_ducktape'

# TESTS FIXME kill all browsers before and after the test
require 'test/spec'

describe 'firefox.new has option key :attach that does not start new browser' do
  
  before :each do
    @b = FireWatir::Firefox.start 'file:///' + File.dirname(__FILE__) + '/../html/person.html'
    sleep 5
  end
  
  after :each do
    @b.close
    sleep 5
  end
  
  it 'new with option :atach => true attaches to existing window and does not start new window' do
    @b.title.should == 'Person'
    b = FireWatir::Firefox.new :attach => true
    b.title.should == 'Person'
  end
  
  it 'why does attach instance method throw exception when only one window exists on the desktop' do
    assert_raise(Watir::Exception::NoMatchingWindowFoundException) do
      b = @b.attach :title, 'Person'
    end
  end
  
  it 'why does attach instance method throw exception when attaching to original window while another exists' do
    b = FireWatir::Firefox.start 'file:///' + File.dirname(__FILE__) + '/../html/census.html'
    sleep 3
    assert_raise(Watir::Exception::NoMatchingWindowFoundException) do
      c = b.attach :title, 'Person' #attach to the setup window
    end
  end
  
end
