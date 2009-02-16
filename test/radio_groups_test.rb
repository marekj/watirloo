require File.dirname(__FILE__) + '/test_helper'

describe 'RadioGroup class access in watir browser' do
  before :each do
    @page = Watirloo::Page.new
    @page.browser.goto testfile('radio_group.html')
    @browser = @page.browser
  end
  
  it 'browser responds to radio_group' do
    @browser.respond_to?(:radio_groups).should == true
  end
  
  it 'returns RadioGroups class' do
    @browser.radio_groups.class.should == Watir::RadioGroups
  end
  
  it 'lenght returns integer count of groups' do
    @browser.radio_groups.length.should == 2
  end
  
  it 'each iterator returns RadioGroup' do
    @browser.radio_groups.each do |rg|
      rg.class.should == Watir::RadioGroup #single
    end
  end
  
  it 'each accesses the group and returns name' do
    names =[]
    @browser.radio_groups.each do |rg|
      names << rg.name
    end
    names.should == ['food', 'fooda']
  end
  
  it 'bracket access[] returns 1-based indexed group' do
    @browser.radio_groups[1].class.should == Watir::RadioGroup
    @browser.radio_groups[1].values.should == ["hotdog", "burger", "tofu"]
    @browser.radio_groups[2].name.should == 'fooda'
  end
  
  it 'if radio group does not exists it returns size 0 or name nil (or should it blow up? or respond to exists? method' do
    @browser.radio_groups[6].size.should == 0 # does not exist. let's not blow up. suggestions?
    @browser.radio_groups[6].name.should == nil #suggestions?
  end
  
  it 'groups contained by a form element' do
    @browser.forms[1].radio_groups.length.should == 1
    names =[]
    @browser.forms[1].radio_groups.each do |rg|
      names << rg.name
    end 
    names.should == ['food']
  end

end
