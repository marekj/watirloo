require 'spec_helper'

describe 'browser checkbox_groups method' do

  before :each do
    @browser = Watirloo::browser
    @browser.goto testfile('checkbox_group1.html')
  end
  
  it 'browser responds to checkbox_groups method' do
    @browser.should respond_to(:checkbox_groups)
  end
  
  it 'returns CheckboxGroups object' do
    @browser.checkbox_groups.class.to_s.should match(/CheckboxGroups/)
  end

  it 'lenght returns integer count of groups' do
    @browser.checkbox_groups.length.should == 4
  end

  it 'each iterator returns CheckboxGroup object 4 times' do
    obj = []
    @browser.checkbox_groups.each do |cbg|
      obj << cbg
    end
    obj.length.should == 4
    obj.each {|x| x.class.to_s.should match(/CheckboxGroup/)}
  end

  it 'each accesses the group and returns name' do
    names =[]
    @browser.checkbox_groups.each do |cg|
      names << cg.name
    end
    names.should == ['pets', 'singleIndicator', 'petsa', 'singleIndicatora']
  end

  it 'bracket access[] returns 1-based indexed group' do
    @browser.checkbox_groups[1].class.to_s.should match(/CheckboxGroup/)
    @browser.checkbox_groups[1].values.should == %w[cat dog zook zebra wumpa]
    @browser.checkbox_groups[3].name.should == 'petsa'
  end

  it 'page should have 2 checkbox groups in form 2' do
    @browser.form(:index, 2).checkbox_groups.length.should == 2
    names =[]
    @browser.form(:index, 2).checkbox_groups.each do |cbg|
      names << cbg.name
    end 
    names.should == ['petsa', 'singleIndicatora']
  end

end
