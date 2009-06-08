require File.dirname(__FILE__) + '/test_helper'

describe "Storage for browsers so we can reattach to them later for tests" do
  
  def remove_storage_file
    #require 'FileUtils'
    #puts File.expand_path(Watirloo::Browsers::Storage.file_path)
    FileUtils.rm_f(Watirloo::Browsers::Storage.file_path) if FileTest.exist?(Watirloo::Browsers::Storage.file_path)
  end


  context "storage file does not exist. create it" do

    it "mapping should return empty hash" do
      Watirloo::Browsers::Storage.mapping.clear
      remove_storage_file
      FileTest.exist?(Watirloo::Browsers::Storage.file_path).should be_false
      Watirloo::Browsers::Storage.mapping.should == {}
    end

    it "clear should create storage file save empty mapping" do
      Watirloo::Browsers::Storage.clear
      FileTest.exist?(Watirloo::Browsers::Storage.file_path).should be_true
      Watirloo::Browsers::Storage.mapping.should == {}
    end
  end

  context "storage is empty. add new browser to storage" do

    it 'add stores ie.hwnd with friendly name and adds it to mapping accepts either ie or hwnd as value' do
      ie = Watir::IE.new
      Watirloo::Browsers::Storage.add('one', ie)
      Watirloo::Browsers::Storage.add('two', ie.hwnd)
    end

    it 'mapping holds what was added' do
      Watirloo::Browsers::Storage.mapping.keys.sort.should == ['one', 'two']
      Watirloo::Browsers::Storage.mapping['one'].should == Watirloo::Browsers::Storage.mapping['two']
    end

    it 'remove deletes a key value record ' do
      Watirloo::Browsers::Storage.remove 'two'
      Watirloo::Browsers::Storage.mapping.keys.should_not include('two')
    end
  end

  context 'reattach to browser and close it' do
    it 'browser returns reference to named browser based on windows handle' do
      ie = Watirloo::Browsers::Storage.browser 'one'
      ie.should be_kind_of(Watir::IE)
      ie.hwnd.should == Watirloo::Browsers::Storage.mapping['one']
      ie.should exist
      ie.close
      ie.should_not exist
    end
  end

  context 'no browsers for records in storage' do
    it 'browser attach to nonexisting windows behaves like IE.attach, it raises error' do
      sleep 6 # if previous test closes a browser we need to wait to ensure we don't reattach to a closing browser
      (lambda {Watirloo::Browsers::Storage.browser('one')}).should raise_error(Watir::Exception::NoMatchingWindowFoundException) #points to the same hwnd as 'one' but at this time does not exist any more
    end
  end

end


