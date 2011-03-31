require 'spec_helper'
  

describe "Locker" do

  it "locker file does not exist. create it. mapping should return empty hash" do
    Watirloo::Locker.mapping.clear
    FileUtils.rm_f(Watirloo::Locker.locker) if FileTest.exist?(Watirloo::Locker.locker) #remove locker file
    FileTest.exist?(Watirloo::Locker.locker).should be_false
    Watirloo::Locker.mapping.should == {}
  end

  it "clear should create locker file and save empty mapping" do
    Watirloo::Locker.clear
    FileTest.exist?(Watirloo::Locker.locker).should be_true
    Watirloo::Locker.mapping.should == {}
  end

  it 'add stores ie.hwnd with friendly name and adds it to mapping' do
    ie = Watir::IE.new
    Watirloo::Locker.add(ie, 'one')
    Watirloo::Locker.add(ie, 'two')
  end

  it 'mapping holds what was added' do
    Watirloo::Locker.mapping.keys.sort.should == ['one', 'two']
    Watirloo::Locker.mapping['one'].should == Watirloo::Locker.mapping['two']
  end

  it 'remove deletes a key value record ' do
    Watirloo::Locker.remove 'two'
    Watirloo::Locker.mapping.keys.should_not include('two')
  end

  it 'browser reattaches to named browser based on windows handle' do
    ie = Watirloo::Locker.browser 'one'
    ie.should be_kind_of(Watir::IE)
    ie.hwnd.should == Watirloo::Locker.mapping['one']
    ie.should exist
    ie.close
    ie.should_not exist
  end

  it 'browser attach to nonexisting windows behaves like IE.attach, it raises error' do
    sleep 6 # if previous test closes a browser we need to wait to ensure we don't reattach to a closing browser
    (lambda {Watirloo::Locker.browser('one')}).should raise_error(Watir::Exception::NoMatchingWindowFoundException) #points to the same hwnd as 'one' but at this time does not exist any more
  end
  
end
