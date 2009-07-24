require File.dirname(__FILE__) + '/spec_helper'

describe "Watirloo browser when no browsers on desktop nor in locker" do

  before(:all) do
    Watirloo::Desktop.clear
    Watirloo::Locker.clear
  end

  it "should start a default new browser and load a testfile" do
    browser = Watirloo.browser
    browser.should be_kind_of(Watir::IE)
    browser.goto testfile('person.html')
  end
  
  it 'should attach to a default browser with loaded testfile and return its title' do
    browser = Watirloo.browser
    browser.should be_kind_of(Watir::IE)
    browser.title.should == 'Person'
  end
  
  it "should start second browser with a named keyword" do
    Watirloo.browser 'second'
  end

  it 'should attach to second browser with keyword and navigate to a testfile' do
    browser2 = Watirloo.browser 'second'
    browser2.goto testfile('census.html')
  end
    
  it 'should attach to two distinct browsers by key values by kewords used to start them' do
    b2 = Watirloo.browser 'second'
    b1 = Watirloo.browser 'default'
    b2.title.should == 'Census'
    b1.title.should == 'Person'
  end

end