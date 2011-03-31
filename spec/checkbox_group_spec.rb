require 'spec_helper'

describe 'browser checkbox_group accesses a group of checkboxes sharing the same name on a page' do

  before :each do
    @browser = Watirloo.browser
    @browser.goto testfile('checkbox_group1.html')
  end

  it 'browser responds to checkbox_group' do
    @browser.should respond_to(:checkbox_group)
  end

  it 'access by name as default returns CheckboxGroup' do
    if @browser.kind_of?(FireWatir::Firefox)
      @browser.checkbox_group('pets').should be_kind_of(FireWatir::CheckboxGroup)
    elsif  @browser.kind_of?(Watir::IE)
      @browser.checkbox_group('pets').should be_kind_of(Watir::CheckboxGroup)
    end
  end

  it 'size retuns checkboxes as items count in a group' do
    @browser.checkbox_group('pets').size.should == 5
  end

  it 'values returns array of value attributes for each checkbox in a group' do
    @browser.checkbox_group('pets').values.should == ["cat", "dog", "zook", "zebra", "wumpa"]
  end

end

describe "checkbox_group values when no checkbox is checked in a group" do

  before :each do
    @browser = Watirloo.browser
    @browser.goto testfile('checkbox_group1.html')
  end

  it 'user_value should be false when no checkbox checked in a group' do
    @browser.checkbox_group('pets').user_value.should be_false
  end
  it 'selected_values should return empty array' do
    @browser.checkbox_group('pets').selected_values.should be_empty
  end

  it "set? should return false when no checkbox is checked in a group" do
    @browser.checkbox_group("pets").should_not be_set
  end

end

describe "checkbox_group values when set string selecs one item only" do

  before :each do
    @browser = Watirloo.browser
    @browser.goto testfile('checkbox_group1.html')
  end


  it "selected should return the string used to select it" do
    @browser.checkbox_group('pets').set 'dog'
    @browser.checkbox_group('pets').user_value.should == 'dog'
  end

  it "selected_value should return the string when one item is selected" do
    @browser.checkbox_group('pets').set 'dog'
    @browser.checkbox_group('pets').selected_values.should == ['dog']
  end

  it "set? should return truee when 1 checkbox is checked in a group" do
    @browser.checkbox_group('pets').set 'dog'
    @browser.checkbox_group("pets").should be_set
  end

end


describe "checkbox_group set array of strings selects multiple values in a group" do

  before :each do
    @browser = Watirloo.browser
    @browser.goto testfile('checkbox_group1.html')
  end


  it "selected returns array of strings when multiple values are selected" do
    @browser.checkbox_group('pets').set ['dog', 'zebra', 'cat'] # not in order
    @browser.checkbox_group('pets').user_value.should == ['cat', 'dog', 'zebra']
  end

  it "set? should return truee when more than 1 checkbox is checked in a group" do
    @browser.checkbox_group('pets').set ['cat', 'zebra', 'dog'] # not in order
    @browser.checkbox_group("pets").should be_set
  end

end

describe "checkbox_group set by numberical position" do

  before :each do
    @browser = Watirloo::browser
    @browser.goto testfile('checkbox_group1.html')
  end


  it 'set Fixnum checks checkbox by position in a group. Position is 1 based.' do
    #Behaves like select by single value
    @browser.checkbox_group('pets').set 3
    @browser.checkbox_group('pets').user_value.should == 'zook'
  end

  it 'set array of Fixnums checks each checkbox by position' do
    #behaves like select multiple strings
    @browser.checkbox_group('pets').set [4, 1, 2] # not in order
    @browser.checkbox_group('pets').user_value.should == ["cat", "dog", "zebra"]
  end
end
