require File.dirname(__FILE__) + '/spec_helper'


describe "Watirloo browser" do
  
  context "There are no browsers on desktop" do
    it "browser method starts a new browser and loads a page" do
      Watirloo::Desktop.clear
      browser = Watirloo.browser
      browser.should be_kind_of(Watir::IE)
      browser.goto testfile('person.html')
    end
  end

  context "there is one browser on the desktop and storage contains its hwnd" do
    it 'browser should returns stored browser ref to existing browser on desktop' do
      browser = Watirloo.browser
      browser.should be_kind_of(Watir::IE)
      browser.title.should == 'Person'
    end
  end
  
  context "start second browser and store it in Storage" do
    it 'browser with key name starts a new browser and stores it for later usage' do
      browser2 = Watirloo.browser 'second'
      browser2.goto testfile('census.html')
    end
    
    it 'browser given key attaches to uniquelly identified browser' do
      b2 = Watirloo.browser 'second'
      b1 = Watirloo.browser 'default'
      b2.title.should == 'Census'
      b1.title.should == 'Person'
    end

  end

end