require File.dirname(__FILE__) + '/spec_helper'


describe "Watirloo Desktop" do

  it "clear closes all browsers on the desktop and browsers should be empty" do
    Watirloo::Desktop.clear
    Watirloo::Desktop.browsers.should be_empty
  end

  it "adding first browser should report 1 addition and no deletions" do
    hwnds = Watirloo::Desktop.hwnds
    Watir::IE.start
    added = Watirloo::Desktop.additions(hwnds)
    added.size.should == 1
    Watirloo::Desktop.deletions(hwnds).should be_empty
  end
  
  it 'while one browser on the desktop the additions and deletions should be false' do
    hwnds = Watirloo::Desktop.hwnds
    hwnds.size.should == 1
    Watirloo::Desktop.additions(hwnds).should be_empty
    Watirloo::Desktop.deletions(hwnds).should be_empty
  end

  it 'adding second browser should report one addition and no deletions' do
    hwnds = Watirloo::Desktop.hwnds
    Watir::IE.start
    Watirloo::Desktop.additions(hwnds).size.should == 1
    Watirloo::Desktop.deletions(hwnds).should be_empty
    Watirloo::Desktop.hwnds.size.should == 2
  end

  it 'close one should report 1 deletion and no additions, attempt to attach to deleted cause exception' do
    hwnds = Watirloo::Desktop.hwnds
    Watirloo::Desktop.browsers[0].close #close any
    Watirloo::Desktop.additions(hwnds).should be_empty
    deleted = Watirloo::Desktop.deletions(hwnds)
    deleted.size.should == 1
    lambda{ Watir::IE.attach :hwnd, deleted[0]}.should raise_error
  end

  
  it "close one and start new one should report one addition and one deletion" do
    hwnds = Watirloo::Desktop.hwnds
    hwnds.size.should == 1
    Watir::IE.start
    (Watir::IE.attach(:hwnd, hwnds[0])).close
    sleep 5
    Watirloo::Desktop.additions(hwnds).size.should == 1
    Watirloo::Desktop.deletions(hwnds).size.should == 1
  end

end
