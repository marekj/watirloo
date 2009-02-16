require File.dirname(__FILE__) + '/test_helper'

describe 'checkbox_groups access for browser' do
  before :each do
    page = Watirloo::Page.new
    @browser = page.browser
    @browser.goto testfile('checkbox_group1.html')
  end
  
  it 'browser responds to checkbox_group' do
    @browser.respond_to?(:checkbox_groups).should == true
  end
  
  it 'returns group object and its values from the page' do
    @browser.checkbox_groups.class.should == Watir::CheckboxGroups
  end

    it 'lenght returns integer count of groups' do
    @browser.checkbox_groups.length.should == 4
  end

  it 'each iterator returns CheckboxGroup' do
    @browser.checkbox_groups.each do |rg|
      rg.class.should == Watir::CheckboxGroup #single
    end
  end

  it 'each accesses the group and returns name' do
    names =[]
    @browser.checkbox_groups.each do |cg|
      names << cg.name
    end
    names.should == ['pets', 'singleIndicator', 'petsa', 'singleIndicatora']
  end
  
  it 'bracket access[] returns 1-based indexed group' do
    @browser.checkbox_groups[1].class.should == Watir::CheckboxGroup
    @browser.checkbox_groups[1].values.should == %w[cat dog zook zebra wumpa]
    @browser.checkbox_groups[3].name.should == 'petsa'
  end
  
  it 'if checkbox group does not exists it returns size 0 or name nil (or should it blow up? or respond to exists? method' do
    @browser.checkbox_groups[6].size.should == 0 # does not exist. let's not blow up. suggestions?
    @browser.checkbox_groups[6].name.should == nil #suggestions?
  end
  
  it 'return checkbox groups contained by the form element' do
    @browser.forms[2].checkbox_groups.length.should == 2
    names =[]
    @browser.forms[2].checkbox_groups.each do |cbg|
      names << cbg.name
    end 
    names.should == ['petsa', 'singleIndicatora']
  end

end
