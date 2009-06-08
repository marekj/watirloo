require File.dirname(__FILE__) + '/test_helper'


describe "Browsers on the Desktop" do
  context "clear desktop of all browsers and start one browser" do
    it "clear closes all browsers on the desktop. browsers should be empty" do
      Watirloo::Browsers::Desktop.clear
      Watirloo::Browsers::Desktop.browsers.should be_empty
    end

    it "adding first browser should report 1 addition and no deletions" do
      hwnds = Watirloo::Browsers::Desktop.hwnds
      Watir::IE.start
      added = Watirloo::Browsers::Desktop.additions(hwnds)
      added.size.should == 1
      Watirloo::Browsers::Desktop.deletions(hwnds).should be_empty
    end
  end

  context "start with one browser and add a new one" do
    it 'while one browser on the desktop the additions and deletions should be false' do
      hwnds = Watirloo::Browsers::Desktop.hwnds
      hwnds.size.should == 1
      Watirloo::Browsers::Desktop.additions(hwnds).should be_empty
      Watirloo::Browsers::Desktop.deletions(hwnds).should be_empty
    end

    it 'adding second browser should report one addition and no deletions' do
      hwnds = Watirloo::Browsers::Desktop.hwnds
      Watir::IE.start
      Watirloo::Browsers::Desktop.additions(hwnds).size.should == 1
      Watirloo::Browsers::Desktop.deletions(hwnds).should be_empty
      Watirloo::Browsers::Desktop.hwnds.size.should == 2
    end

  end

  context "start with 2 browsers, close one and end up with one" do
    it 'close one should report 1 deletion and no additions, attempt to attach to deleted cause exception' do
      hwnds = Watirloo::Browsers::Desktop.hwnds
      Watirloo::Browsers::Desktop.browsers[0].close #close any
      Watirloo::Browsers::Desktop.additions(hwnds).should be_empty
      deleted = Watirloo::Browsers::Desktop.deletions(hwnds)
      deleted.size.should == 1
      lambda{ Watir::IE.attach :hwnd, deleted[0]}.should raise_error
    end

  end

  context "while one browser on desktop, close it and start new one." do
    it "should report one addition and one deletion" do
      hwnds = Watirloo::Browsers::Desktop.hwnds
      hwnds.size.should == 1
      Watir::IE.start
      (Watir::IE.attach(:hwnd, hwnds[0])).close
      sleep 5
      Watirloo::Browsers::Desktop.additions(hwnds).size.should == 1
      Watirloo::Browsers::Desktop.deletions(hwnds).size.should == 1
    end
  end
end
