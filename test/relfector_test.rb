require File.dirname(__FILE__) + '/test_helper'

# each collection can reflect the accessors and specs for its own members



describe 'reflect :text_fields' do
  before :each do
    @page = Watirloo::Page.new
    @page.browser.goto testfile('person.html')
    @browser = @page.browser
  end
  
  it 'reflects each :text_field' do
    reflection = [
      "face :last_nm => [:text_field, :name, \"last_nm\"]",
      "last_nm.value.should == \"Begoodnuffski\"",
      "face :first_nm => [:text_field, :name, \"first_nm\"]",
      "first_nm.value.should == \"Joanney\"",
      "face :dob => [:text_field, :name, \"dob\"]",
      "dob.value.should == \"05/09/1964\"",
      "face :addr1 => [:text_field, :name, \"addr1\"]",
      "addr1.value.should == \"1600 Transylavnia Ave.\""]

    @browser.text_fields.reflect.should == reflection
    
  end

end

describe 'reflect :radio_groups' do
  before :each do
    @page = Watirloo::Page.new
    @page.browser.goto testfile('radio_group.html')
    @browser = @page.browser
  end
  
  it 'reflects each radio group' do
    reflection = [
      "face :food => [:radio_group, 'food']",
      "food.values.should == [\"hotdog\", \"burger\", \"tofu\"]",
      "food.selected.should == \"burger\"",
      "face :fooda => [:radio_group, 'fooda']",
      "fooda.values.should == [\"hotdoga\", \"burgera\", \"tofua\"]",
      "fooda.selected.should == \"tofua\""]
    
    @browser.radio_groups.reflect.should == reflection
  end
end

describe 'reflect :checkbox_groups' do
  before :each do
    @page = Watirloo::Page.new
    @page.browser.goto testfile('checkbox_group1.html')
    @browser = @page.browser
  end
  
  it 'reflects each checkbox_group' do
    reflection = [
      "face :pets => [:checkbox_group, 'pets']",
      "pets.values.should == [\"cat\", \"dog\", \"zook\", \"zebra\", \"wumpa\"]",
      "pets.selected.should == nil",
      "face :singleIndicator => [:checkbox_group, 'singleIndicator']",
      "singleIndicator.values.should == [\"on\"]",
      "singleIndicator.selected.should == nil",
      "face :petsa => [:checkbox_group, 'petsa']",
      "petsa.values.should == [\"cata\", \"doga\", \"zooka\", \"zebraa\", \"wumpaa\"]",
      "petsa.selected.should == nil",
      "face :singleIndicatora => [:checkbox_group, 'singleIndicatora']",
      "singleIndicatora.values.should == [\"on\"]",
      "singleIndicatora.selected.should == nil"]
        
    @browser.checkbox_groups.reflect.should == reflection
  end
  

end