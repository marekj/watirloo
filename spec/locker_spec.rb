require File.dirname(__FILE__) + '/spec_helper'

describe "Storage Locker for browsers so we can reattach to them later for tests" do
  
  def remove_locker_file
    #require 'FileUtils'
    #puts File.expand_path(Watirloo::Locker.locker)
    FileUtils.rm_f(Watirloo::Locker.locker) if FileTest.exist?(Watirloo::Locker.locker)
  end


  context "locker file does not exist. create it" do

    it "mapping should return empty hash" do
      Watirloo::Locker.mapping.clear
      remove_locker_file
      FileTest.exist?(Watirloo::Locker.locker).should be_false
      Watirloo::Locker.mapping.should == {}
    end

    it "clear should create locker file save empty mapping" do
      Watirloo::Locker.clear
      FileTest.exist?(Watirloo::Locker.locker).should be_true
      Watirloo::Locker.mapping.should == {}
    end
  end

  context "locker is empty. add new browser to storage" do

    it 'add stores ie.hwnd with friendly name and adds it to mapping accepts either ie or hwnd as value' do
      ie = Watir::IE.new
      Watirloo::Locker.add('one', ie)
      Watirloo::Locker.add('two', ie.hwnd)
    end

    it 'mapping holds what was added' do
      Watirloo::Locker.mapping.keys.sort.should == ['one', 'two']
      Watirloo::Locker.mapping['one'].should == Watirloo::Locker.mapping['two']
    end

    it 'remove deletes a key value record ' do
      Watirloo::Locker.remove 'two'
      Watirloo::Locker.mapping.keys.should_not include('two')
    end
  end

  context 'reattach to browser and close it' do
    it 'browser returns reference to named browser based on windows handle' do
      ie = Watirloo::Locker.browser 'one'
      ie.should be_kind_of(Watir::IE)
      ie.hwnd.should == Watirloo::Locker.mapping['one']
      ie.should exist
      ie.close
      ie.should_not exist
    end
  end

  context 'no browsers for records stored in locker' do
    it 'browser attach to nonexisting windows behaves like IE.attach, it raises error' do
      sleep 6 # if previous test closes a browser we need to wait to ensure we don't reattach to a closing browser
      (lambda {Watirloo::Locker.browser('one')}).should raise_error(Watir::Exception::NoMatchingWindowFoundException) #points to the same hwnd as 'one' but at this time does not exist any more
    end
  end

end

